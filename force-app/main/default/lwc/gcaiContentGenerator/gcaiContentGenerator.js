import { LightningElement , api, wire } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getGeneratedContent from '@salesforce/apex/GCAI_PromptCtrl.getGeneratedContent';

const COPY_URL_SUCCESS_MESSAGE = 'Copy text to clipboard succeeded.';
export default class GcaiContentGenerator extends LightningElement {
	@api generativeResult;
	@api recordId;
	@api objectApiName;

    isLoading = false;
    title = 'Generate Content';
    requestPromptText = '';
    error;
    selectedText = 'Text sample';
    selectedModelURL = 'gpt-3.5-turbo-instruct';
    generatedText = '';

    closeModal() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
    handlePromptChange(event) {
        this.requestPromptText = event.target.value;
    }
    // Handle API request to GPT
    handleLLMRequest() {
        this.isLoading = true;
        getGeneratedContent({ requestPromptText: this.requestPromptText, modelURL: this.selectedModelURL })
            .then((result) => {
                console.log(`## GPT RESULT RETURN ${JSON.stringify(result)}`);
                if (result.length > 0){
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

}