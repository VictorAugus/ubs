import { LightningElement, api ,track} from 'lwc';

export default class InputConditional extends LightningElement {
    @api respostaItem = '';
    @api respostaObservacao = '';
    @api respostaId = '';
    @api  inputValue = ''; // Esta propriedade irá armazenar o valor digitado no input

    get valueInput(){
        return   this.respostaObservacao;

    }
    get mostrarInputObservacao() {
        console.log('this.respostaItem',this.respostaItem)
        return  this.respostaItem === 'Observação';
    }
    handleInputChange(event) {
        this.inputValue = event.target.value;
        console.log('this.inputValue',this.inputValue)
        const inputEvent = new CustomEvent('blur', {
            detail: this.inputValue
        });
        this.dispatchEvent(inputEvent);
    }
}