import { LightningElement , api, wire } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getGeneratedContent from '@salesforce/apex/GCAI_PromptCtrl.getGeneratedContent';
import getModels from '@salesforce/apex/GCAI_PromptCtrl.getModels';

export default class GcaiContentGenerator extends LightningElement {
	@api generativeResult;
	@api recordId;
	@api objectApiName;

    isLoading = false;
    title = 'New ideas';
    requestPromptText = '';
    error;
    selectedText = 'Text sample';
    modelOptions = [];
    selectedModelURL = '';

    closeModal() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
    handlePromptChange(event) {
        this.requestPromptText = event.target.value;
    }
    handleModelChange(event){
        this.selectedModelURL = event.detail.value;
    }
    connectedCallback() {
        this.getLLMModels();
    }
    getLLMModels(){
        this.isLoading = true;
        getModels()
        .then((data) => {
            if (data && data.length > 0) {
                console.log('### getModels: '+JSON.stringify(data))
                for(var i=0; i<data.length; i++)  {
                    console.log(`## MODEL ID: ${data[i].id}`);
                    this.modelOptions = [...this.modelOptions, {value: data[i].id , label: data[i].id} ];   
                                                    
                }                
                this.error = undefined;
            }else{
                // Handle error Toast
                this.error = data.error;
                const evt = new ShowToastEvent({
                    title: 'GPT Error response',
                    message: data.error.error.message, // comming from wrapper error class
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
    // Handle API request to GPT
    handleLLMRequest() {
        this.isLoading = true;
        getGeneratedContent({ requestPromptText: this.requestPromptText, modelURL: this.selectedModelURL })
            .then((result) => {
                console.log(`## GPT RESULT RETURN ${JSON.stringify(result)}`);
                if (result.length > 0){
                    this.generativeResult = result; // Array of data can be 1
                    console.log(`GPT Result: ${this.generativeResult[0]}`);
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

}