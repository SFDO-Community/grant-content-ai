import { LightningElement , api, wire } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getModels from '@salesforce/apex/GCAI_PromptCtrl.getModels';

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from 'lightning/messageService';
import CONTENT_DATA_CHANNEL from '@salesforce/messageChannel/GCAI_Content_Data__c';

export default class GcaiModelSelector extends LightningElement {
	@api selectedModel;
	@api recordId;
	@api objectApiName;
    
    isLoading = false;
    error;
    title = 'Model Selector';
    modelOptions = [];
    displayLabel = 'Model';

    @wire(MessageContext)
    messageContext;

    // Respond to UI event by publishing message
    handleContactSelect(event) {
        const payload = { model: this.selectedModel };

        publish(this.messageContext, CONTENT_DATA_CHANNEL, payload);
    }    
    handleModelChange(event){
        this.selectedModel = event.detail.value;
        this.displayLabel = `Model: ${this.selectedModel}`;

        const payload = { model: this.selectedModel };

        publish(this.messageContext, CONTENT_DATA_CHANNEL, payload);

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