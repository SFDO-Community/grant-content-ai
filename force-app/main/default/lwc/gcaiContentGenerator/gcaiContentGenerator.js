import { LightningElement , api, wire } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getGeneratedContent from '@salesforce/apex/GCAI_PromptCtrl.getGeneratedContent';
// Import message service features required for publishing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import CONTENT_DATA_CHANNEL from '@salesforce/messageChannel/GCAI_Content_Data__c';
import TemplateModal from 'c/gcaiPromptTemplateModal';

const COPY_URL_SUCCESS_MESSAGE = 'Copy text to clipboard succeeded.';
export default class GcaiContentGenerator extends LightningElement {
	@api generativeResult;
	@api recordId;
	@api objectApiName;
    subscription = null;
    textAreaFormats = ['']; // Empty array of formats removes all rich text editor toolbar buttons
    isLoading = false;
    title = 'Generate Content';
    promptText = '';
    error;
    selectedText = 'Text sample';
    selectedModelURL = 'gpt-3.5-turbo-instruct';
    generatedText = '';
    rawTextData = '';

    closeModal() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
    handlePromptChange(event) {
        this.promptText = event.target.value;
        console.log(`## TEST input ${this.promptText}`);
    }
    handleTextClearButtonClick(){
        this.promptText = '';
        this.generativeResult = '';
    }
    // Handle API request to GPT
    handleLLMRequest() {
        this.isLoading = true;
        const regex = /(<([^>]+)>)/ig;
        this.rawTextData = this.promptText.replace(regex, '');
        console.log(`## Input text ${this.rawTextData}`);
        getGeneratedContent({ requestPromptText: this.rawTextData, modelURL: this.selectedModelURL })
            .then((result) => {
                console.log(`## GPT RESULT Promise`);
                if (result && result.length > 0){
                    console.log(`## GPT RESULT RETURN ${JSON.stringify(result)}`);
                    this.generativeResult = result; // Array of data can be 1
                    console.log(`GPT Result: ${this.generativeResult[0]}`);
                    if(this.generativeResult[0].text){
                       this.generatedText = this.generativeResult[0].text;
                    }
                    this.error = undefined;
                }else{
                    // Handle error Toast
                    this.error = result.error;
                    const evt = new ShowToastEvent({
                        title: 'GPT Error response',
                        message: result.error.error.message, // comming from wrapper error class
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);    
                }
                this.isLoading = false;
            })
            .catch((error) => {
                this.error = error;
                this.generativeResult = undefined;
                this.isLoading = false;
                this.error = result.error;
                const evt = new ShowToastEvent({
                    title: 'GPT Error response',
                    message: this.error, 
                    variant: 'error',
                });
                this.dispatchEvent(evt);    

            });
    }  
    handleCopyText(){
        console.log('Content copy start');
        this.copyLegacyMethod();
        /* This standard method in JS copy to clipboard does not work in SF LEX need to use old alternative method
        const copyContent = async () => {
            try {
              await navigator.clipboard.writeText(this.generativeResult[0]);
              console.log(`Content copied to clipboard ${this.generativeResult[0]}`);
            } catch (err) {
              console.error('Failed to copy: ', err);
            }
          }
        */
    }
    // TODO: Update this method when a standard browser clipboard API will work in Lightning
    // This method is legacy using deprecated JS API execCommand it is working in Lightning
    copyLegacyMethod(){
        //create and input element
        var inputEle = document.createElement("input");
        window.console.log("@Value@", this.generatedText);
        //set the value attribute
        inputEle.setAttribute("value", this.generatedText);
        //append element to document body
        document.body.appendChild(inputEle);
        // selects all the text  in an < input > element that includes a text field.
        inputEle.select();
        // Copies the current selection to the clipboard
		// --- THIS IS DEPRECATED METHOD However there are no good substitute yet for COPY, everyone keep using this
        document.execCommand("copy");
        // remove element temp
        inputEle.parentNode.removeChild(inputEle);

		const evt = new ShowToastEvent({
			title: 'Copy Generated Text',
			message: COPY_URL_SUCCESS_MESSAGE,
			variant: 'success',
		});
		this.dispatchEvent(evt);		
    }

    // By using the MessageContext @wire adapter, unsubscribe will be called
    // implicitly during the component descruction lifecycle.
    @wire(MessageContext) messageContext;

    // Encapsulate logic for LMS subscribe.
    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            CONTENT_DATA_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    // Handler for message received by model selector component
    handleMessage(message) {
        this.selectedModelURL = message.model;
    }

    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    async handleTemplateOpenClick() {
        const result = await TemplateModal.open({
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        // console.log(result);
        // Copy selected template prompt result to send API request
        this.promptText = result;
    }
}