import { LightningElement , api } from "lwc";
import GeneratorModal from 'c/gcaiContentGeneratorModal';

export default class GcaiModalLauncher extends LightningElement {
	@api recordId;
	@api objectApiName;

    async handleOpenClick(){
        const result = await GeneratorModal.open({
            size: 'large',
            description: 'Content Generator description of modal\'s purpose',
            content: 'Pass content to api',
        });
        console.log(result);
    }
}