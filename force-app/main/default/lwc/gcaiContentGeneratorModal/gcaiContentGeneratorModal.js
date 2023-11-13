import { LightningElement , api } from "lwc";
import LightningModal from 'lightning/modal';

export default class GcaiContentGeneratorModal extends LightningModal {
	@api recordId;
	@api objectApiName;

    handleCloseModal() {
        this.close('okay');
    }
}