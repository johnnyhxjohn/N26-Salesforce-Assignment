import { LightningElement, api, wire, track } from 'lwc';
import getPlanServices from '@salesforce/apex/ContactPlanDetailsController.getPlanServices';

const columns = [
    { label: 'Service', fieldName: 'name' },
    { label: 'Price', fieldName: 'priceFormatted' },
    { label: 'Fee', fieldName: 'fee'},
];

export default class ContactPlanDetails extends LightningElement {
    
    @api recordId; // Case Id
    planDetails;
    columns = columns;
    loading = true;
    
    @wire(getPlanServices, {recordId: '$recordId'})
    wiredContact({ error, data }) {
        if (data) {
            this.planDetails = data;
            this.loading = false;
        } else if (error) {
            console.error('Error retrieving contact:', error);
        }
    }
}