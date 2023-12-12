import { LightningElement , api, wire } from "lwc";
import LightningModal from 'lightning/modal';
import getTemplateList from '@salesforce/apex/GCAI_PromptTemplateCtrl.getTemplates';

export default class GcaiPromptTemplateModal extends LightningModal {
	@api recordId;
	@api objectApiName;
	isSelected = false; 
	// Query list of saved prompt template form Salesforce
	@wire(getTemplateList) templates;
	// Cancel modal without using any template
	handleCancel() {
        this.close('Enter text');
    }	
	// Use selected template. Select button will also close the modal
	handleTemplateSelectClick(evt){
		
		console.log(`### Template select event: ${evt.target.name}`);
		let tmpSamples = JSON.parse(JSON.stringify(this.templates.data));
		for(var i=0; i<tmpSamples.length; i++)  {
            try {
                if(tmpSamples[i].Id === evt.target.name){
                	console.log(`### Sample: ${tmpSamples[i].Name}`);
					this.close(tmpSamples[i].Sample_Prompt__c);
				}
			}catch(err) {
                console.log('## ERROR: '+err.message);
            }
		}
	}
}