import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import {FlowNavigationBackEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport'

/**
 * @classdesc Classe ajuda DW
 */
export default class DwLwcHelper {
    static toast = {
        info: function(message, config = {}){
            this.dispatchEvent(new ShowToastEvent(
                {
                    ...{
                        title: config?.title ?? 'Informação!',
                        message,
                        variant: 'info'
                    },
                    ...config
                }
            ))
        },
        success: function(message, config = {}){
            this.dispatchEvent(new ShowToastEvent(
                {
                    ...{
                        title: config?.title ?? 'Sucesso!',
                        message,
                        variant: 'success'
                    },
                    ...config
                }
            ))
        },
        warning: function(message, config = {}){
            this.dispatchEvent(new ShowToastEvent(
                {
                    ...{
                        title: config?.title ?? 'Alerta!',
                        message,
                        variant: 'warning'
                    },
                    ...config
                }
            ))
        },
        error: function(message, config = {}){
            this.dispatchEvent(new ShowToastEvent(
                {
                    ...{
                        title: config?.title ?? 'Erro!',
                        message,
                        variant: 'error'
                    },
                    ...config
                }
            ))
        }
    }

    /**
     * @returns {object} Retorna o dataMap do DW_ResponseHTTP analisado
     * @description Valida se o response do DW_ResponseHTTP contém erros, caso exista, um throw é emitido com o response
     */
    static validateDwResponseHTTP(response) {
        let responseBody = JSON.parse(response)
        if (!responseBody?.success) throw this.getErrorList(responseBody)
        return responseBody?.dataMap
    }

    /**
     * @description Só pra não ficar JSON JSON JSON toda hora
     */
    static parseProxy(proxy) {
        return JSON.parse(JSON.stringify(proxy))
    }

    static getErrorList(responseBody) {
        console.error('responseBody', responseBody)
        return responseBody.errorList.map(errorItem => {
            return this.refineErrorMessage(errorItem)
        }).join(';')
    }

    static refineErrorMessage(errorMessage) {
        if (errorMessage?.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
            return errorMessage.split('FIELD_CUSTOM_VALIDATION_EXCEPTION:')[1]?.split('Você pode consultar')[0] ?? errorMessage
        }
        return errorMessage
    }

    static getUrlHost(){
        return `https://${window.location.host.replace('lightning', 'my')}`
    }

    static _hasAction(actions, term){
        return actions?.some(action => action === term)
    }

    static flow = {
        back: function(){
            if (DwLwcHelper._hasAction(this.availableActions, 'BACK')) this.dispatchEvent(new FlowNavigationBackEvent())
            else this.dispatchEvent(new FlowNavigationFinishEvent())
        },
        next: function(){
            if (DwLwcHelper._hasAction(this.availableActions, 'NEXT')) this.dispatchEvent(new FlowNavigationNextEvent())
            else this.dispatchEvent(new FlowNavigationFinishEvent())
        },
        finish: function(){
            this.dispatchEvent(new FlowNavigationFinishEvent())
        }
    }
}