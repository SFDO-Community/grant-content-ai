import { LightningElement , api } from "lwc";
import GeneratorModal from 'c/gcaiContentGeneratorModal';

export default class GcaiModalLauncher extends LightningElement {
	@api
	recordId;
	@api
	objectApiName;

    async handleOpenClick(){
        const result = await GeneratorModal.open({
            // `label` is not included here in this example.
            // it is set on lightning-modal-header instead
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}