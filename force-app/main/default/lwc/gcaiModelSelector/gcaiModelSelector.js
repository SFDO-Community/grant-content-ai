import { LightningElement , api } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getModels from '@salesforce/apex/GCAI_PromptCtrl.getModels';

export default class GcaiModelSelector extends LightningElement {
	@api selectedModel;
	@api recordId;
	@api objectApiName;
    
    isLoading = false;
    error;
    title = 'Model Selector';
    modelOptions = [];
    displayLabel = 'Model';

    handleModelChange(event){
        this.selectedModel = event.detail.value;
        this.displayLabel = `Model: ${this.selectedModel}`;
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
                    //console.log(`## MODEL ID: ${data[i].id}`);
                    this.modelOptions = [...this.modelOptions, {value: data[i].id , label: data[i].id} ];                       
                }                
                this.error = undefined;
            }else{
                // Handle error Toast
                this.error = data.error;
                const evt = new ShowToastEvent({
                    title: 'Error response',
                    message: data.error.error.message, // coming from wrapper error class
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
                title: 'Error response',
                message: this.error, 
                variant: 'error',
            });
            this.dispatchEvent(evt);    

        });

    }

}