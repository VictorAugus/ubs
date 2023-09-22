import {
    api,
    LightningElement,
    track,
    wire
} from 'lwc';
import {
    FlowNavigationBackEvent,
    FlowNavigationNextEvent
} from "lightning/flowSupport";

import NAME_FIELD from "@salesforce/schema/Account.Name";
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import BILLING_STREET_FIELD from "@salesforce/schema/Account.BillingStreet";
import BILLING_CITY_FIELD from "@salesforce/schema/Account.BillingCity";
import BILLING_STATE_FIELD from "@salesforce/schema/Account.BillingState";
import NUMERO_FIELD_FIELD from "@salesforce/schema/Account.Numero__c";
import CriadoPeloContato_FIELD from "@salesforce/schema/Account.CriadoPeloContato__c";


import NAME_FIELD_AMBIENTE from "@salesforce/schema/Ambiente__c.Name";
import TIPO_FIELD_AMBIENTE from '@salesforce/schema/Ambiente__c.Tipo__c';
import COBERTURA_FIELD_AMBIENTE from '@salesforce/schema/Ambiente__c.Cobertura__c';
import LARGURA_FIELD_AMBIENTE from '@salesforce/schema/Ambiente__c.LarguraDimensao__c';
import COMPRIMENTO_FIELD_AMBIENTE from '@salesforce/schema/Ambiente__c.Comprimento__c';
import PEDIREITO_FIELD_AMBIENTE from '@salesforce/schema/Ambiente__c.PeDireito__c';
import UBS_FIELD_AMBIENTE from '@salesforce/schema/Ambiente__c.UBS__c';


import IMAGES from "@salesforce/resourceUrl/static_images";
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import DwLwcHelper from 'c/dwLwcHelper'

import sendEmailToController from '@salesforce/apex/ControllerAuthLwc.sendEmailToController'
import getUnidadesToController from '@salesforce/apex/ControllerAuthLwc.getUnidadesByContact'
import accountVinculoRecMethod from '@salesforce/apex/ControllerAuthLwc.accountVinculoRecMethod'
import accountRecMethod from '@salesforce/apex/ControllerAuthLwc.accountRecMethod';
import accountDeleteRecMethod from '@salesforce/apex/ControllerAuthLwc.accountDeleteRecMethod';
import getAmbientes from '@salesforce/apex/ControllerAuthLwc.getAmbientesByContact';
import accountDeleteAmbiente from '@salesforce/apex/ControllerAuthLwc.accountDeleteAmbiente';
import getQuestionsByAmbiente from '@salesforce/apex/ControllerAuthLwc.getQuestionsByAmbiente';
import getQuestionsByUnidade from '@salesforce/apex/ControllerAuthLwc.getQuestionsByUnidade';

import getQuestionsByAmbienteUpdateResposta from '@salesforce/apex/ControllerAuthLwc.getQuestionsByAmbienteUpdateResposta';
import getQuestionsByUnidadeUpdateResposta from '@salesforce/apex/ControllerAuthLwc.getQuestionsByUnidadeUpdateResposta';
import getQuestionsByUnidadeUpdateObs from '@salesforce/apex/ControllerAuthLwc.getQuestionsByUnidadeUpdateObs';

import createAmbienteRecMethod from '@salesforce/apex/ControllerAuthLwc.createAmbienteRecMethod';

import getAnswersVinculoRecMethod from '@salesforce/apex/ControllerAuthLwc.getAnswersVinculoRecMethod';
import { createRecord } from 'lightning/uiRecordApi';

export default class LoginComponent extends LightningElement {
    @track observacaoTrue = false; 
    @track uniqueSectionId = '';
    @track secoesAbertasPorPadrao = ['Critérios'];
    @track      activeSections = [ ];
    @track accordianOpenSection=[];
    @api  respostaItem;

    @track todasSecoesAbertas = true;
    @track secaoAbertaPorPadrao = true;

    valueRespostaAmbiente = 'Faça sua escolha';

    get optionsAmbiente() {
        return [{
                label: 'Péssimo',
                value: 'Péssimo'
            },
            {
                label: 'Ruim',
                value: 'Ruim'
            },
            {
                label: 'Regular',
                value: 'Regular'
            },
            {
                label: 'Bom',
                value: 'Bom'
            },
            {
                label: 'Excelente',
                value: 'Excelente'
            },
            {
                label: 'Não se aplica	',
                value: 'Não se aplica'
            },
        ];
    }
    @track fullUrl

    @track perguntas = [];
    @track perguntasAmbientes = [];
    @track perguntasAmbientesUnidade = []

    @track perguntasAmbientesGroupUnidade = []
    @track tipoAmbienteList = [];
    @track coberturaAmbienteList = [];
    @track valueTipoAmbiente;
    @track perguntaRespostaAmbiente;
    @track valueCoberturaAmbiente;
    @track nameAmbiente = NAME_FIELD_AMBIENTE;
    @track tipoAmbiente = TIPO_FIELD_AMBIENTE;
    @track coberturaAmbiente = COBERTURA_FIELD_AMBIENTE;
   @track valorInputObs = '';
    @track larguraAmbiente = LARGURA_FIELD_AMBIENTE;
    @track comprimentoAmbiente = COMPRIMENTO_FIELD_AMBIENTE;
    @track ubsAmbiente = UBS_FIELD_AMBIENTE;
    @track pedireitoAmbiente = PEDIREITO_FIELD_AMBIENTE;


    recAmbiente = {

        Name: this.nameAmbiente,
        Tipo__c: this.tipoAmbiente,
        UBS__c: this.UBSAmbiente,
        Cobertura__c: this.coberturaAmbiente,
        
        LarguraDimensao__c: this.larguraAmbiente,
        Comprimento__c: this.comprimentoAmbiente,
        PeDireito__c: this.pedireitoAmbiente,

    }
    @track inputValueFromChild = '';

    @track name = NAME_FIELD;
    @track billingStreet = BILLING_STREET_FIELD;
    @track billingCity = BILLING_CITY_FIELD;
    @track billingState = BILLING_STATE_FIELD;
    @track billingNumero = NUMERO_FIELD_FIELD;
    @track phone = PHONE_FIELD;
    @track CriadoPeloContato__c = CriadoPeloContato_FIELD;

    recAccount = {

        Name: this.name,
        Phone: this.phone,
        BillingStreet: this.billingStreet,
        BillingCity: this.billingCity,
        BillingState: this.billingState,
        Numero__c: this.billingNumero,
        CriadoPeloContato__c: this.CriadoPeloContato__c

    }
    get mostrarInput() {
        console.log('this.respostaItem',this.respostaItem )
        // Substitua 'item.Resposta__c' pela propriedade real do seu item
        const resposta = this.respostaItem ;

        // Verifique se o item.Resposta__c é igual a 'Observação'
        return resposta === 'Observação';
    }

    login_auth = IMAGES + '/static_images/images/login_auth.png';

    renderedCallback() {
        const sections = this.template.querySelectorAll('lightning-accordion-section[data-parent="' + this.uniqueSectionId + '"]');
        if (sections) {
            sections.forEach(section => {
                section.classList.remove('slds-is-closed');
                section.classList.add('slds-is-open');
            });
        }
    }
    get options() {
        return [{
                label: 'COORDENADOR UBS',
                value: 'COORDENADOR UBS'
            },
            {
                label: 'Engenheiro/Arquiteto',
                value: 'Engenheiro/Arquiteto'
            },
            {
                label: 'Gestor de Departamento',
                value: 'Gestor de Departamento'
            },
            {
                label: 'Diretor da secretaria',
                value: 'Diretor da secretaria'
            },
            {
                label: 'Administrador',
                value: 'Administrador'
            },
        ];
    }

    @api availableActions = [];
    unidades = [];
    grupoAmbientes = [];
    isOpenQuestion = false
    grupoAmbientesByQuestions = [];
    isCloseQuestion = false
    username;
    password;
    @track errorCheck;
    @track errorMessage;
    @api recordId;
    @api usuario;
    @api primeironome;
    @api ultimonome;
    @api senha;
    @api escolha;
    @api msgAviso;
    inputsCreated = false
    islogged = false
    isCloseUnidadeQuestion = false
    isOpenQuestionUnidade = false
    isCreateAmbiente = false
    isCreateUnidade = false
    isSearchUnidade = false
    iconName;
    iconAmbienteName;
    iconQuestionsName;
    iconDashboardName;
    @api cargo;
    selectedEnvId
    miterFields = ['Altura__c', 'Largura__c', 'InstaladaFachada__c', 'AreaIluminacao__c', 'AreaVentilacao__c']
    loading = false

    handleSectionClick(event){
        const clickedSectionName = event.target.name;
    console.log('clickedSectionName',clickedSectionName)
    // Verifique se a seção clicada é diferente da que já está aberta
    if (this.secaoAbertaAutomaticamente !== clickedSectionName) {
        this.secaoAbertaAutomaticamente = clickedSectionName;
  
        // Agora, você pode abrir automaticamente as seções filhas
        const ambiente = this.categoria.ambientes.find(amb => amb.nome === clickedSectionName);
        if (ambiente) {
            const subcategorias = ambiente.subcategorias.map(subcat => subcat.nome);
            this.secaoAbertaAutomaticamente = [...subcategorias];
            console.log('secaoAbertaAutomaticamente',secaoAbertaAutomaticamente)
            console.log('subcategoria',subcategoria)

            // Simule o clique em cada subcategoria
            subcategorias.forEach(subcategoria => {
                const subcategoriaElement = this.template.querySelector(`[name="${subcategoria}"]`);
                if (subcategoriaElement) {
                    subcategoriaElement.click(); // Aciona o clique na subcategoria
                }
            });
        }
      } else {
        // Se a seção clicada já está aberta, feche-a
        this.secaoAbertaAutomaticamente = '';
      }

    }
    async handleNSAplicaRespostaUnidade(event) {
        console.log('caiuNãoseAplica')

        console.log('event.target.dataset.id', event.target.dataset.id)
        let resultado = 'Não se aplica'
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray


        // segunda onda
        const groupedData = [];

        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const ambienteNome = item.Ambiente__r?.Name || "Critérios";
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;

            let categoriaObj = groupedData.find(cat => cat.nome === categoria);
            if (!categoriaObj) {
                categoriaObj = {
                    nome: categoria,
                    ambientes: []
                };
                groupedData.push(categoriaObj);
            }

            let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
            if (!ambienteObj) {
                ambienteObj = {
                    nome: ambienteNome,
                    subcategorias: []
                };
                categoriaObj.ambientes.push(ambienteObj);
            }

            let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoria,
                    secoes: []
                };
                ambienteObj.subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
            if (!secaoObj) {
                secaoObj = {
                    nome: secao,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: pergunta,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        console.log(groupedData);
        
        console.log('groupedData',groupedData);
        console.log('groupedData_json', JSON.stringify(groupedData))
        this.perguntasAmbientesGroupUnidade =groupedData
    }
    handleSectionToggle(event) {
        console.log('abrir_guia')
    }
    handleSectionToggleGrupo(event){
        console.log('abrir_evento')

        const accordion = this.template.querySelector('lightning-accordion');
        console.log('accordion',accordion)

    if (accordion) {
      const sections = accordion.querySelectorAll('lightning-accordion-section');
      console.log('sections',sections)
      if (sections.length > 0) {
        const sectionNames = [];
        sections.forEach(section => {
          sectionNames.push(section.getAttribute('name'));
        });
        console.log('sectionNames',sectionNames)
        this.accordianOpenSection = sectionNames.join(',');
      }
    }

        //this.accordianOpenSection = [];

           
           



    }
    async handleExcelenteRespostaUnidade(event) {
        console.log('caiuExecelente_unidade')
        let resultado = 'Excelente'
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        // segunda onda
        const groupedData = [];

        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const ambienteNome = item.Ambiente__r?.Name || "Critérios";
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;

            let categoriaObj = groupedData.find(cat => cat.nome === categoria);
            if (!categoriaObj) {
                categoriaObj = {
                    nome: categoria,
                    ambientes: []
                };
                groupedData.push(categoriaObj);
            }

            let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
            if (!ambienteObj) {
                ambienteObj = {
                    nome: ambienteNome,
                    subcategorias: []
                };
                categoriaObj.ambientes.push(ambienteObj);
            }

            let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoria,
                    secoes: []
                };
                ambienteObj.subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
            if (!secaoObj) {
                secaoObj = {
                    nome: secao,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: pergunta,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        console.log(groupedData);
        
        console.log('groupedData',groupedData);
        console.log('groupedData_json', JSON.stringify(groupedData))
        this.perguntasAmbientesGroupUnidade =groupedData
    }
    async handleBomRespostaUnidade(event) {
        let resultado = 'Bom'
        console.log('caiuBom')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        // segunda onda
        const groupedData = [];

        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const ambienteNome = item.Ambiente__r?.Name || "Critérios";
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;

            let categoriaObj = groupedData.find(cat => cat.nome === categoria);
            if (!categoriaObj) {
                categoriaObj = {
                    nome: categoria,
                    ambientes: []
                };
                groupedData.push(categoriaObj);
            }

            let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
            if (!ambienteObj) {
                ambienteObj = {
                    nome: ambienteNome,
                    subcategorias: []
                };
                categoriaObj.ambientes.push(ambienteObj);
            }

            let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoria,
                    secoes: []
                };
                ambienteObj.subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
            if (!secaoObj) {
                secaoObj = {
                    nome: secao,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: pergunta,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        console.log(groupedData);
        
        console.log('groupedData',groupedData);
        console.log('groupedData_json', JSON.stringify(groupedData))
        this.perguntasAmbientesGroupUnidade =groupedData
    }
    async handleRegularRespostaUnidade(event) {
        let resultado = 'Regular'
        console.log('caiuRegular')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        // segunda onda
        const groupedData = [];

        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const ambienteNome = item.Ambiente__r?.Name || "Critérios";
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;

            let categoriaObj = groupedData.find(cat => cat.nome === categoria);
            if (!categoriaObj) {
                categoriaObj = {
                    nome: categoria,
                    ambientes: []
                };
                groupedData.push(categoriaObj);
            }

            let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
            if (!ambienteObj) {
                ambienteObj = {
                    nome: ambienteNome,
                    subcategorias: []
                };
                categoriaObj.ambientes.push(ambienteObj);
            }

            let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoria,
                    secoes: []
                };
                ambienteObj.subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
            if (!secaoObj) {
                secaoObj = {
                    nome: secao,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: pergunta,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        console.log(groupedData);
        
        console.log('groupedData',groupedData);
        console.log('groupedData_json', JSON.stringify(groupedData))
        this.perguntasAmbientesGroupUnidade =groupedData
    }
    async handleRuimRespostaUnidade(event) {
        let resultado = 'Ruim'
        console.log('caiuRuim')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        // segunda onda
        const groupedData = [];

        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const ambienteNome = item.Ambiente__r?.Name || "Critérios";
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;

            let categoriaObj = groupedData.find(cat => cat.nome === categoria);
            if (!categoriaObj) {
                categoriaObj = {
                    nome: categoria,
                    ambientes: []
                };
                groupedData.push(categoriaObj);
            }

            let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
            if (!ambienteObj) {
                ambienteObj = {
                    nome: ambienteNome,
                    subcategorias: []
                };
                categoriaObj.ambientes.push(ambienteObj);
            }

            let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoria,
                    secoes: []
                };
                ambienteObj.subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
            if (!secaoObj) {
                secaoObj = {
                    nome: secao,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: pergunta,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        console.log(groupedData);
        
        console.log('groupedData',groupedData);
        console.log('groupedData_json', JSON.stringify(groupedData))
        this.perguntasAmbientesGroupUnidade =groupedData
        
    }
     async handleInputChangeInParent(event){
        console.log('event_handleInputChangeInParent',event.detail)
        console.log('event.target.dataset.id', event.target.dataset.id)
        
        if(event.detail === 0){
            return false;
        }
        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateObs({
            respostaId: event.target.dataset.id,
            valorResultado: event.detail
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        //segunda seção
         // segunda onda
         const groupedData = [];

         responseAmbiente.respostaAmbienteList.forEach(item => {
             const categoria = item.Pergunta__r.Categoria__c;
             const subcategoria = item.Pergunta__r.Subcategoria__c;
             const ambienteNome = item.Ambiente__r?.Name || "Critérios";
             const secao = item.Pergunta__r.Secao__c;
             const pergunta = item.Pergunta__r.Pergunta__c;
 
             let categoriaObj = groupedData.find(cat => cat.nome === categoria);
             if (!categoriaObj) {
                 categoriaObj = {
                     nome: categoria,
                     ambientes: []
                 };
                 groupedData.push(categoriaObj);
             }
 
             let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
             if (!ambienteObj) {
                 ambienteObj = {
                     nome: ambienteNome,
                     subcategorias: []
                 };
                 categoriaObj.ambientes.push(ambienteObj);
             }
 
             let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
             if (!subcategoriaObj) {
                 subcategoriaObj = {
                     nome: subcategoria,
                     secoes: []
                 };
                 ambienteObj.subcategorias.push(subcategoriaObj);
             }
 
             let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
             if (!secaoObj) {
                 secaoObj = {
                     nome: secao,
                     perguntas: []
                 };
                 subcategoriaObj.secoes.push(secaoObj);
             }
 
             let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
             if (!perguntaObj) {
                 perguntaObj = {
                     nome: pergunta,
                     itens: []
                 };
                 secaoObj.perguntas.push(perguntaObj);
             }
 
             perguntaObj.itens.push(item);
         });
 
         console.log(groupedData);
         
         console.log('groupedData',groupedData);
         console.log('groupedData_json', JSON.stringify(groupedData))
         this.perguntasAmbientesGroupUnidade =groupedData

    }
    async handlePessimoRespostaUnidade(event) {
        let resultado = 'Péssimo'
        console.log('caiuPessimo')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidadeUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        //segunda seção
         // segunda onda
         const groupedData = [];

         responseAmbiente.respostaAmbienteList.forEach(item => {
             const categoria = item.Pergunta__r.Categoria__c;
             const subcategoria = item.Pergunta__r.Subcategoria__c;
             const ambienteNome = item.Ambiente__r?.Name || "Critérios";
             const secao = item.Pergunta__r.Secao__c;
             const pergunta = item.Pergunta__r.Pergunta__c;
 
             let categoriaObj = groupedData.find(cat => cat.nome === categoria);
             if (!categoriaObj) {
                 categoriaObj = {
                     nome: categoria,
                     ambientes: []
                 };
                 groupedData.push(categoriaObj);
             }
 
             let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
             if (!ambienteObj) {
                 ambienteObj = {
                     nome: ambienteNome,
                     subcategorias: []
                 };
                 categoriaObj.ambientes.push(ambienteObj);
             }
 
             let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
             if (!subcategoriaObj) {
                 subcategoriaObj = {
                     nome: subcategoria,
                     secoes: []
                 };
                 ambienteObj.subcategorias.push(subcategoriaObj);
             }
 
             let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
             if (!secaoObj) {
                 secaoObj = {
                     nome: secao,
                     perguntas: []
                 };
                 subcategoriaObj.secoes.push(secaoObj);
             }
 
             let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
             if (!perguntaObj) {
                 perguntaObj = {
                     nome: pergunta,
                     itens: []
                 };
                 secaoObj.perguntas.push(perguntaObj);
             }
 
             perguntaObj.itens.push(item);
         });
 
         console.log(groupedData);
         
         console.log('groupedData',groupedData);
         console.log('groupedData_json', JSON.stringify(groupedData))
         this.perguntasAmbientesGroupUnidade =groupedData
    }
    //ambiente
    async handleNSAplicaResposta(event) {
        console.log('caiuNãoseAplica')

        console.log('event.target.dataset.id', event.target.dataset.id)
        let resultado = 'Não se aplica'
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbienteUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        console.log('responseAmbiente.qtRespostas', JSON.stringify(responseAmbiente.qtRespostas))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray
    }
    async handleExcelenteResposta(event) {
        console.log('caiuExecelente')
        let resultado = 'Excelente'
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbienteUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))

        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        console.log('responseAmbiente.qtRespostas', JSON.stringify(responseAmbiente.qtRespostas))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray

    }
    async handleBomResposta(event) {
        let resultado = 'Bom'
        console.log('caiuBom')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbienteUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        console.log('responseAmbiente.qtRespostas', JSON.stringify(responseAmbiente.qtRespostas))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray
    }
    async handleRegularResposta(event) {
        let resultado = 'Regular'
        console.log('caiuRegular')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbienteUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        console.log('responseAmbiente.qtRespostas', JSON.stringify(responseAmbiente.qtRespostas))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray
    }
    async handleRuimResposta(event) {
        let resultado = 'Ruim'
        console.log('caiuRuim')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbienteUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        console.log('responseAmbiente.qtRespostas', JSON.stringify(responseAmbiente.qtRespostas))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray
    }
    async handlePessimoResposta(event) {
        let resultado = 'Péssimo'
        console.log('caiuPessimo')

        console.log('event.target.dataset.id', event.target.dataset.id)
        console.log('event.target.dataset.id', event.target.dataset.id)

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbienteUpdateResposta({
            respostaId: event.target.dataset.id,
            valorResultado: resultado
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        console.log('responseAmbiente.qtRespostas', JSON.stringify(responseAmbiente.qtRespostas))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray

    }

    handleSectionToggle(event) {
        console.log(event.detail.openSections);
    }

    boot() {
        console.log('initial')
        console.log('msgAviso', this.msgAviso)
        this.inputsCreated = false

    }
    async handleExcludeAmbiente(event) {
        console.log("the selected record id is Id - ambiente", event.target.dataset.id);
        console.log("this.recordId", this.recordId);

        try {

            let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await accountDeleteAmbiente({
                ambienteId: event.target.dataset.id,
                recordId: this.recordId
            }))
            console.log('response', responseAmbiente)

            let auxTable = responseAmbiente.ambientes.map(item => {
                console.log('item', item)
                console.log('item_ambiente', item.Ambientes__r)
                if (item.Ambientes__r === undefined) {

                } else {
                    console.log('item_ambiente_records', item.Ambientes__r.records)
                    item._children = item.Ambientes__r.records
                }
                /*let obj = []
                obj._children = responseAmbiente.ambientes[item].map(item2=>{
                    item2._children = (item2.Ambientes__r ?? []).map(ambiente=>{
                        console.log('ambiente',ambiente)
                        
                    })
                })
                return obj*/
                return item;
            })
            console.log('auxTable_parse', auxTable)

            this.grupoAmbientes = auxTable


            const evt = new ShowToastEvent({
                title: 'Registro excluido!',
                message: 'Ambiente excluido com sucesso!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } catch (e) {

            console.error('ERROR ON get Unidades', e)
            const evt = new ShowToastEvent({
                title: 'Registro não foi excluido!',
                message: e,
                variant: 'ShowToastEvent',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } finally {
            //this.loadingBalance = false
        }

    }

    //ambiente
    handelNamechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)

        this.recAmbiente.Name = event.target.value;
    }
    handelLarAmbientechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)
        this.recAmbiente.LarguraDimensao__c = event.target.value;
    }
    handelAreaComAmbientechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)
        this.recAmbiente.Comprimento__c = event.target.value;
    }
    handelAreaPeAmbientechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)
        this.recAmbiente.PeDireito__c = event.target.value;
    }
    /*handelGrupochangeAmbiente(event) {
        console.log('event.target.value', event.target.value)
        this.recAmbiente.Grupo__c = event.target.value;
    }
    handelUnidadechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)

        this.recAmbiente.Unidade__c = event.target.value;
    }
    handelUnidadechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)

        this.recAmbiente.Unidade__c = event.target.value;
    }
    handelAreaEsqAmbientechangeAmbiente(event) {
        console.log('event.target.value', event.target.value)

        this.recAmbiente.AreaEsquadrias__c = event.target.value;
    }
    handelAreaAmbientechangeAmbiente(event) {
        this.recAmbiente.AreaAmbiente__c = event.target.value;
    }*/
    handelTipochangeAmbiente(event) {
        console.log('event.target.value', event.target.value)
        this.valueTipoAmbiente = event.target.value;

        this.recAmbiente.Tipo__c = event.target.value;
    }
    handelCoberturaChangeAmbiente(event) {
        console.log('event.target.value', event.target.value)
        this.valueCoberturaAmbiente = event.target.value;

        this.recAmbiente.Cobertura__c = event.target.value;
    }

    //conta
    handelNamechange(event) {
        this.recAccount.Name = event.target.value;
        //console.log("name",this.recAccount.Name);
    }
    handelPhonechange(event) {
        this.recAccount.Phone = event.target.value;
        // console.log("phone",this.recAccount.Phone);
    }

    handelbillingStreetchange(event) {
        this.recAccount.BillingStreet = event.target.value;
        // console.log("email",this.recAccount.Rating);
    }

    handebillingStatechange(event) {
        this.recAccount.BillingState = event.target.value;
        //console.log("industry",this.recAccount.Industry);
    }
    handebillingCitychange(event) {
        this.recAccount.BillingCity = event.target.value;
        //console.log("industry",this.recAccount.Industry);
    }
    handeNumero__cchange(event) {
        this.recAccount.Numero__c = event.target.value;
        //console.log("industry",this.recAccount.Industry);
    }
    async createAmbienteRec(event) {
        console.log('criar_ambiente', event.target.dataset.id)
        console.log('valueTipoAmbiente', this.valueTipoAmbiente)
        console.log('valueCoberturaAmbiente', this.valueCoberturaAmbiente)
        this.isCreateAmbiente = false
        this.recAmbiente.UBS__c = event.target.dataset.id;
        this.recAmbiente.Cobertura__c = this.valueCoberturaAmbiente;
        this.recAmbiente.Tipo__c = this.valueTipoAmbiente;
        console.log('recAmbiente', this.recAmbiente)
        try {
            let response = DwLwcHelper.validateDwResponseHTTP(await createAmbienteRecMethod({
                recordId: this.recordId,
                accRecId: event.target.dataset.id,
                ambienteRecord: this.recAmbiente
            }))
            console.log('response', response.ambientes)
            let auxTable = response.ambientes.map(item => {
                console.log('item', item)
                console.log('item_ambiente', item.Ambientes__r)
                if (item.Ambientes__r === undefined) {

                } else {
                    console.log('item_ambiente_records', item.Ambientes__r.records)
                    item._children = item.Ambientes__r.records
                }
                /*let obj = []
                obj._children = responseAmbiente.ambientes[item].map(item2=>{
                    item2._children = (item2.Ambientes__r ?? []).map(ambiente=>{
                        console.log('ambiente',ambiente)
                        
                    })
                })
                return obj*/
                return item;
            })
            console.log('auxTable_parse', auxTable)

            this.grupoAmbientes = auxTable

            const evt = new ShowToastEvent({
                title: 'Registro criado!',
                message: 'Ambiente criada com sucesso!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } catch (e) {

            console.error('ERROR ON get Unidades', e)
            const evt = new ShowToastEvent({
                title: 'Registro não foi criado!',
                message: e,
                variant: 'ShowToastEvent',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } finally {
            //this.loadingBalance = false
        }

    }
    handleAmbienteCreated(event) {
        console.log('criar_tela_ambiente')
        this.isCreateAmbiente = true



    }
    createCancelAmbienteRec(event) {
        this.isCreateAmbiente = false
        console.log('cancelar_ambiente')
    }

    createCancelAccRec(event) {
        console.log('cancelar_registro')
        this.isCreateUnidade = false
        this.isSearchUnidade = false
    }
    handleAccountSearch() {
        this.isCreateUnidade = false
        this.isSearchUnidade = true
        console.log('seach_unidade')
    }
    async handleAccountSelection(event) {
        console.log("the selected record id is" + event.detail);
        this.recAccount.CriadoPeloContato__c = this.recordId
        console.log('vincular', this.recAccount)
        this.isCreateUnidade = false

        try {

            let response = DwLwcHelper.validateDwResponseHTTP(await accountVinculoRecMethod({
                recordId: this.recordId,
                accRecordRec: event.detail
            }))
            console.log('response', response)
            this.unidades = response.response
            this.isSearchUnidade = false

            let auxTable = response.ambientes.map(item => {
                console.log('item', item)
                console.log('item_ambiente', item.Ambientes__r)
                if (item.Ambientes__r === undefined) {

                } else {
                    console.log('item_ambiente_records', item.Ambientes__r.records)
                    item._children = item.Ambientes__r.records
                }
                /*let obj = []
                obj._children = responseAmbiente.ambientes[item].map(item2=>{
                    item2._children = (item2.Ambientes__r ?? []).map(ambiente=>{
                        console.log('ambiente',ambiente)
                        
                    })
                })
                return obj*/
                return item;
            })
            console.log('auxTable_parse', auxTable)

            this.grupoAmbientes = auxTable

            const evt = new ShowToastEvent({
                title: 'Registro vinculado!',
                message: 'Unidade vinculada com sucesso!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);

        } catch (e) {

            console.error('ERROR ON get Unidades', e)
            const evt = new ShowToastEvent({
                title: 'Registro não foi vinculado!',
                message: e,
                variant: 'ShowToastEvent',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } finally {
            //this.loadingBalance = false
        }
    }
    async createAccRec() {
        this.recAccount.CriadoPeloContato__c = this.recordId
        console.log('criar_registro', this.recAccount)
        this.isCreateUnidade = false
        this.isSearchUnidade = false
        try {

            let {
                response
            } = DwLwcHelper.validateDwResponseHTTP(await accountRecMethod({
                recordId: this.recordId,
                accRec: this.recAccount
            }))
            console.log('response', response)
            this.unidades = response

            const evt = new ShowToastEvent({
                title: 'Registro criado!',
                message: 'Unidade criada com sucesso!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } catch (e) {

            console.error('ERROR ON get Unidades', e)
            const evt = new ShowToastEvent({
                title: 'Registro não foi criado!',
                message: e,
                variant: 'ShowToastEvent',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } finally {
            //this.loadingBalance = false
        }

    }
    handleAccountCreated(event) {
        console.log('criar_registro')
        this.isCreateUnidade = true

    }
    closeQuestion(event) {
        this.isOpenQuestion = false
        this.isCloseQuestion = false;

    }
    closeQuestionUnidade(event) {
        this.isOpenQuestionUnidade = false
        this.isCloseUnidadeQuestion = false;
        this.accordianOpenSection = [];
    }
 
    async getQuestionByUnidade(event) {
        this.isCloseUnidadeQuestion = true;
        this.loading = true;
        console.log('buscarPerguntas', event.target.dataset.id)
        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByUnidade({
            recordId: this.recordId,
            unidadeId: event.target.dataset.id
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        const listNomes = [];

        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            if (!listNomes.includes(categoria)) {
                listNomes.push(categoria);
              }
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestionUnidade = true;
        this.perguntasAmbientesUnidade = groupedArray
        console.log('respostaAmbienteList_resposta_json', JSON.stringify(this.perguntasAmbientesUnidade))
        // segunda onda
                const groupedData = [];

        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            if (!listNomes.includes(subcategoria)) {
                listNomes.push(subcategoria);
              }
            const ambienteNome = item.Ambiente__r?.Name || "Critérios";
            if (!listNomes.includes(ambienteNome)) {
                listNomes.push(ambienteNome);
              }
            const secao = item.Pergunta__r.Secao__c;
            if (!listNomes.includes(secao)) {
                listNomes.push(secao);
              }
            const pergunta = item.Pergunta__r.Pergunta__c;

            let categoriaObj = groupedData.find(cat => cat.nome === categoria);
            if (!categoriaObj) {
                categoriaObj = {
                    nome: categoria,
                    ambientes: []
                };
                groupedData.push(categoriaObj);
            }

            let ambienteObj = categoriaObj.ambientes.find(amb => amb.nome === ambienteNome);
            if (!ambienteObj) {
                ambienteObj = {
                    nome: ambienteNome,
                    subcategorias: []
                };
                categoriaObj.ambientes.push(ambienteObj);
            }

            let subcategoriaObj = ambienteObj.subcategorias.find(sub => sub.nome === subcategoria);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoria,
                    secoes: []
                };
                ambienteObj.subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secao);
            if (!secaoObj) {
                secaoObj = {
                    nome: secao,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === pergunta);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: pergunta,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        console.log(groupedData);
        
        console.log('groupedData',groupedData);
        console.log('groupedData_json', JSON.stringify(groupedData))
        this.perguntasAmbientesGroupUnidade =groupedData
        this.loading = false;
        this.secaoAbertaPorPadrao = true

        console.log('listNomes',JSON.stringify(listNomes))
        this.accordianOpenSection = listNomes
    }

    async getQuestion(event) {
        this.isCloseQuestion = true;
        console.log('buscarPerguntas', event.target.dataset.id)
        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getQuestionsByAmbiente({
            recordId: this.recordId,
            ambienteId: event.target.dataset.id
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', JSON.stringify(responseAmbiente.respostaAmbienteList))
        this.perguntaRespostaAmbiente = 'Total Perguntas: ' +responseAmbiente.qtRespostas.QuantidadeResposta__c +'/ Total Respostas realizadas: '+responseAmbiente.qtRespostas.QuantidadeRespostasFinalizadas__c; 
        const groupedByCategoria = {};
        responseAmbiente.respostaAmbienteList.forEach(item => {
            const categoria = item.Pergunta__r.Categoria__c;
            const subcategoria = item.Pergunta__r.Subcategoria__c;
            const secao = item.Pergunta__r.Secao__c;
            const pergunta = item.Pergunta__r.Pergunta__c;
            const categoriaNome = item.Pergunta__r.Categoria__c;
            const subcategoriaNome = item.Pergunta__r.Subcategoria__c;
            const secaoNome = item.Pergunta__r.Secao__c;
            const perguntaNome = item.Pergunta__r.Pergunta__c;

            if (!groupedByCategoria[categoria]) {
                groupedByCategoria[categoria] = {
                    nome: categoriaNome,
                    subcategorias: []
                };
            }

            let subcategoriaObj = groupedByCategoria[categoria].subcategorias.find(sub => sub.nome === subcategoriaNome);
            if (!subcategoriaObj) {
                subcategoriaObj = {
                    nome: subcategoriaNome,
                    secoes: []
                };
                groupedByCategoria[categoria].subcategorias.push(subcategoriaObj);
            }

            let secaoObj = subcategoriaObj.secoes.find(sec => sec.nome === secaoNome);
            if (!secaoObj) {
                secaoObj = {
                    nome: secaoNome,
                    perguntas: []
                };
                subcategoriaObj.secoes.push(secaoObj);
            }

            let perguntaObj = secaoObj.perguntas.find(perg => perg.nome === perguntaNome);
            if (!perguntaObj) {
                perguntaObj = {
                    nome: perguntaNome,
                    itens: []
                };
                secaoObj.perguntas.push(perguntaObj);
            }

            perguntaObj.itens.push(item);
        });

        const groupedArray = Object.values(groupedByCategoria);
        console.log(groupedArray);
        console.log(groupedArray);

        // Agora você tem os objetos agrupados por subcategoria e seção em groupedArray
        this.isOpenQuestion = true;
        this.perguntasAmbientes = groupedArray
        console.log('respostaAmbienteList_resposta_json', JSON.stringify(this.perguntasAmbientes))
    }
    async handleActivePerguntas(event) {
        console.log('evento_perguntas')

        let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getAnswersVinculoRecMethod({
            ambienteId: event.target.dataset.id,
            recordId: this.recordId
        }))
        console.log('response', responseAmbiente)
        console.log('respostaAmbienteList_resposta', responseAmbiente.respostaAmbienteList)
        console.log('respostaAmbienteList_resposta_json', JSON.stringify(responseAmbiente.respostaAmbienteList))

        let auxTable = responseAmbiente.ambientes.map(item => {
            console.log('item', item)
            console.log('item_ambiente', item.Ambientes__r)
            if (item.Ambientes__r === undefined) {

            } else {
                console.log('item_ambiente_records', item.Ambientes__r.records)
                item._children = item.Ambientes__r.records
            }
            /*let obj = []
            obj._children = responseAmbiente.ambientes[item].map(item2=>{
                item2._children = (item2.Ambientes__r ?? []).map(ambiente=>{
                    console.log('ambiente',ambiente)
                    
                })
            })
            return obj*/
            return item;
        })
        console.log('auxTable_parse', auxTable)


        this.grupoAmbientes = auxTable



    }
    async handleClickDelete(event) {
        console.log('delete')
        console.log("the selected record id is Id", event.target.dataset.id);

        try {

            let response = DwLwcHelper.validateDwResponseHTTP(await accountDeleteRecMethod({
                recordId: this.recordId,
                ctRelationRecordRec: event.target.dataset.id
            }))
            console.log('response', response)
            this.unidades = response.response

            let auxTable = response.ambientes.map(item => {
                console.log('item', item)
                console.log('item_ambiente', item.Ambientes__r)
                if (item.Ambientes__r === undefined) {

                } else {
                    console.log('item_ambiente_records', item.Ambientes__r.records)
                    item._children = item.Ambientes__r.records
                }
                /*let obj = []
                obj._children = responseAmbiente.ambientes[item].map(item2=>{
                    item2._children = (item2.Ambientes__r ?? []).map(ambiente=>{
                        console.log('ambiente',ambiente)
                        
                    })
                })
                return obj*/
                return item;
            })
            console.log('auxTable_parse', auxTable)

            this.grupoAmbientes = auxTable

            const evt = new ShowToastEvent({
                title: 'Registro desvinculado!',
                message: 'Unidade desvinculada com sucesso!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } catch (e) {

            console.error('ERROR ON get Unidades', e)
            const evt = new ShowToastEvent({
                title: 'Registro não foi excluido!',
                message: e,
                variant: 'ShowToastEvent',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        } finally {
            //this.loadingBalance = false
        }


    }

    async viewTableUnidades(event) {
        console.log('buscarUnidades', this.recordId)

        try {

            let {
                response
            } = DwLwcHelper.validateDwResponseHTTP(await getUnidadesToController({
                recordId: this.recordId
            }))

            console.log('response', response)
            this.unidades = response

            let responseAmbiente = DwLwcHelper.validateDwResponseHTTP(await getAmbientes({
                recordId: this.recordId
            }))
            console.log('responseAmbiente', responseAmbiente)
            console.log('JSON.stringify(results)', JSON.stringify(responseAmbiente));
            console.log('responseAmbiente', responseAmbiente.ambientes)
            console.log('optionsAmbientes', responseAmbiente.optionsAmbientes)

            //this.ambientes = responseAmbiente
            for (const [i, j] of Object.entries(responseAmbiente.optionsAmbientes)) {
                console.log('j', j)
                this.tipoAmbienteList.push({
                    label: j,
                    value: j
                });
            }
            for (const [i, j] of Object.entries(responseAmbiente.optionsCobertura)) {
                console.log('j', j)
                this.coberturaAmbienteList.push({
                    label: j,
                    value: j
                });
            }
            console.log('this.tipoAmbienteList', this.tipoAmbienteList)


            //tipoAmbienteList
            let auxTable = responseAmbiente.ambientes.map(item => {
                console.log('item', item)
                console.log('item_ambiente', item.Ambientes__r)
                if (item.Ambientes__r === undefined) {

                } else {
                    console.log('item_ambiente_records', item.Ambientes__r.records)
                    item._children = item.Ambientes__r.records
                }
                /*let obj = []
                obj._children = responseAmbiente.ambientes[item].map(item2=>{
                    item2._children = (item2.Ambientes__r ?? []).map(ambiente=>{
                        console.log('ambiente',ambiente)
                        
                    })
                })
                return obj*/
                return item;
            })
            console.log('auxTable_parse', auxTable)

            this.grupoAmbientes = auxTable

        } catch (e) {

            console.error('ERROR ON get Unidades', e)
        } finally {
            //this.loadingBalance = false
        }


    }
    connectedCallback() {
        this.uniqueSectionId = 'section_' + Math.random().toString(36).substring(7);

        this.fullUrl='https://daspeweb-e-dev-ed.develop.my.site.com/s/dashboard/01Z6e000000NPB0/testepainel';
        this.iconName = "utility:company";
        this.iconAmbienteName = "utility:ad_set";
        this.iconQuestionsName = "utility:question";
        this.iconDashboardName = "utility:service_report";

        if (this.recordId) {
            this.islogged = true
            console.log('buscarUnidades')
            this.viewTableUnidades()

        }
        this.inputsCreated = false
        if (this.msgAviso === 'já existe esse email cadastrado.') {
            const evt = new ShowToastEvent({
                title: 'Preenchimento',
                message: 'Já existe esse email cadastrado.',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
        if (this.msgAviso != undefined && this.msgAviso.includes("Seja bem vindo")) {
            const evt = new ShowToastEvent({
                title: 'Logado com sucesso!',
                message: this.msgAviso,
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }

        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0");
        document.getElementsByTagName('head')[0].appendChild(meta);
        this.escolha = '';
    }
    handleActiveReports(event){

    }
    handleUserNameChange(event) {

        this.usuario = event.target.value;

    }
    handleCargoChange(event) {

        this.cargo = event.target.value;

    }
    handlePasswordChange(event) {

        this.senha = event.target.value;
    }

    handleFirstNameChange(event) {

        this.primeironome = event.target.value;
    }
    handleLastNameChange(event) {

        this.ultimonome = event.target.value;
    }
    async forgot(event) {

        event.preventDefault()
        this.loading = true
        this.inputsCreated = false
        this.escolha = 'Esqueci meu Usuario/Senha';
        if (this.isEmpty(this.usuario)) {
            const evt = new ShowToastEvent({
                title: 'Preenchimento',
                message: 'Preencha o usuário com seu email para receber a senha cadastrada.',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            this.loading = false

            //alert('Preencha usuario para receber a senha registrada')
        } else {

            try {
            //const navigateNextEvent = new FlowNavigationNextEvent();
            //this.dispatchEvent(navigateNextEvent);    
            this.usuario = this.usuario.replace(/\s/g, '');
            console.log('this.usuario',this.usuario)
            let response = DwLwcHelper.validateDwResponseHTTP(await sendEmailToController({
                toSend: this.usuario
            }))
            console.log('this.response_sendforgot',response)

            
                const evt = new ShowToastEvent({
                    title: 'Solicitação de recuperação de senha recebida',
                    message: 'Aguarde chegar a senha na sua caixa de entrada com mais informações.',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);

            } catch (error) {
                console.error('ERROR ON handleMiterSubmit', error, error.toString())
                

                const evt = new ShowToastEvent({
                    title: 'Não foi possivel realizar a solicitação de recuperação de senha! ',
                    message: error.toString(),
                    variant: 'warning',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);

            } finally {
                this.loading = false
            }
           

        }


    }
    createView(event) {
        this.inputsCreated = true
    }
    notcreate(event) {
        this.inputsCreated = false
        this.escolha = '';
    }
    create(event) {

        this.escolha = 'Criar Conta Nova';
        if (this.isEmpty(this.usuario) || this.isEmpty(this.senha) || this.isEmpty(this.primeironome) || this.isEmpty(this.ultimonome) || this.isEmpty(this.cargo)) {
            const evt = new ShowToastEvent({
                title: 'Preenchimento',
                message: 'Preencha todos os campos para criar uma novo usuário.',
                variant: 'warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            //alert('Preencha usuario e senha para criar uma nova conta')
        } else {
            this.usuario = this.usuario.replace(/\s/g, '');
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }

    }
    isEmpty(str) {
        return (!str || 0 === str.length);
    }
    handleLogin(event) {
        this.inputsCreated = false
        this.escolha = 'entrar registro';
        if (this.isEmpty(this.usuario) || this.isEmpty(this.senha)) {

        } else {
            this.usuario = this.usuario.replace(/\s/g, '');
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);

        }


    }
    handleClickAddMiter(event){
        this.selectedEnvId = event.currentTarget.dataset.env
        console.log('this.selectedEnvId', this.selectedEnvId)
    }

    async handleMiterSubmit(event){
        try {
            event.preventDefault()
            this.loading = true
            let createdRecord = await createRecord({
                fields: {
                    ...event.detail.fields,
                    Ambiente__c: this.selectedEnvId
                },
                apiName: 'Esquadrias__c'
            })
            this.selectedEnvId = null
            console.log('createddd', createRecord)
            DwLwcHelper.toast.success.call(this, 'Esquadria criada com sucesso! Logo vamos melhorar a sua experiência!')
        } catch (error) {
            console.error('ERROR ON handleMiterSubmit', error, error.toString())
            DwLwcHelper.toast.error.call(this, error?.body?.message ?? 'Tivemos um erro ao o registro...')
        } finally {
            this.loading = false
        }
    }
}