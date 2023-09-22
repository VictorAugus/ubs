/**
 * Created by guilhermereis on 15/12/2020.
 */
@isTest
public with sharing class TestFactory {

    public static User getAnyUser() {
        User user = (User) DW_QueryFactory.get('User')
                .setCondition(DW_QueryCondition.newInstance('IsActive', '=', true))
                .setCondition(DW_QueryCondition.newInstance('UserType', '=', 'Standard'))
                .run()
                .get(0);
        return user;
    }

    public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'Conta teste';
        // acc.StatusCadastro__c = 'Finalizado';
        // acc.Documento__c = '16557984000146';
        // acc.DataAberturaEmpresa__c = System.today().addDays(-200);//todo mudar o tipo desse campo
        // acc.StatusConta__c = 'Ativo';
        // acc.NomeFantasia__c = 'Teste';

    //    acc.AprovacaoEnderecoEntrega__c = 'Aprovado';
    //    acc.FormaPagamento__c = 'BO';
        insert acc;
        return acc;
    }

    public static Account feedAccountFields(String recordTypeDevName){
        final integer STRING_LENGTH = 14;
        final integer MAX = Integer.valueOf(Math.pow(10,STRING_LENGTH) - 1); // Returns 999
        String aleaNumberN = String.valueOf(Math.Round(Math.Random() * MAX)).leftPad(STRING_LENGTH,'0');

        Integer len = 4;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, len);


        Account acc = new Account();
        // acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();

        acc.AccountSource = 'Anúncio';
        acc.BillingCity = 'São José dos Pinhais';
        acc.BillingCountry = 'Brasil';
        acc.BillingPostalCode = '06230110';
        acc.BillingState = 'SP';
        acc.BillingStreet = 'R ANHANGUERA, 425 , S/N, PIRATININGA' ;
        // acc.CodigoMunicipioCobranca__c = '3534401';
        // acc.DataAberturaEmpresa__c = System.today().addDays(-200);//todo mudar o tipo desse campo

        acc.ShippingCity = 'São José dos Pinhais';
        acc.ShippingCountry = 'Brasil';
        acc.ShippingPostalCode = '06230110';
        acc.ShippingState = 'SP';
        acc.ShippingStreet = 'R ANHANGUERA, 425 , S/N, PIRATININGA' ;
        // acc.CodigoMunicipio__c = '3534401';

        // acc.CapitalSocial__c = 100000;
        // acc.CodigoFilial__c = '01';//todo verificar como esse campo é atribuído
        // acc.Documento__c = aleaNumberN;
        // acc.EmailNFe__c = 'daspe'+Decimal.valueOf(Math.random()*1000000).setScale(0)+'web@gmail.com';
        // acc.Email__c = 'daspe'+Decimal.valueOf(Math.random()*1000000).setScale(0)+'web@gmail.com';
        // acc.Documento__c = aleaNumberN;
        // acc.InscricaoEstadual__c = '492952007117';
        // acc.InscricaoMunicipalConta__c = '123456';
        acc.Name = aleaNumberN;
        // acc.NaturezaIntegracao__c = '206-2 - Sociedade Empresária Limitada';
        // acc.NomeEmpresarial__c = 'SALVABRAS SOLUCOES EM PROTECAO LTDA';
        // acc.NomeFantasia__c = 'SALVABRAS';
        // acc.Contribuinte__c = true;
        // acc.OptanteSimplesNacional__c = false;
        // acc.pais_bacen_conta__c = '01058';
        // acc.pais_conta__c = '105';
        // acc.PerfilConta__c = 'Loja de tintas';
        acc.Phone = '11 '+randomNumber+' '+randomNumber;
        // acc.Porte__c = 'ME';
        // acc.RamoAtividadeConta__c = 'Revenda';
        // acc.RazaoSocial__c = 'INFORMAÇÃO NÃO OBTIDA';
        // acc.SiglaNaturezaJuridica__c = 'ltda';
        // acc.Situacao__c = 'ATIVA';
        // acc.SituacaoCNPJ__c = 'Ativo';
        // acc.SituacaoEspecial__c = '********';
        // acc.SituacaoInscricaoEstadual__c = '********';
        // acc.SituacaoEspecial__c = 'NÃO enquadrado no SIMEI';
        // acc.SituacaoSimeiAnteriror__c = 'Não Existem';
        // acc.SituacaoSimplesNacionalAnterior__c = '04/07/2012|31/12/2014|Excluída por Opção do Contribuinte';
        // acc.SituacaSimplesNacional__c = 'NÃO optante pelo Simples Nacional';
        // acc.StatusConta__c = 'Ativo';
        // acc.StatusIntegracao__c = 'Executado com sucesso';
        // acc.tipo_pessoa_conta__c = 'J - Juridica';
        // acc.TipoVendedor__c = 'Parceiro';
        acc.Website = 'www.salvabras.com.br';
        if(!recordTypeDevName.equals('Transportadora'))
        	// acc.StatusCadastro__c = 'Finalizado';
        System.debug('acc...'+acc.Name);
        System.debug('acc...'+acc.Phone);

        return acc;
    }

    public static Account createAccountClienteType(){
        Account acc = feedAccountFields('Cliente');
        insert acc;
        return acc;
    }

    public static Account createAccountTransportadoraType(){
        Account acc = feedAccountFields('Transportadora');
        insert acc;
        return acc;
    }

    public static Account createAccountVendedorType(){
        Account acc = feedAccountFields('Vendedor');
        insert acc;
        return acc;
    }
    public static Account createAccountMotoristaType(){
        Account acc = feedAccountFields('Motorista');
        insert acc;
        return acc;
    }
    public static Contact createContact(Account account){
        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.FirstName = 'Guilherme';
        contact.LastName = 'Reis';
        contact.Phone = '41 9 99887766';
        contact.MobilePhone = '41 9 99887766';
        contact.HomePhone = '41 9 99887766';
        contact.OtherPhone = '41 9 99887766';
        contact.AssistantPhone = '41 9 99887766';
        contact.Email = 'daspe'+Decimal.valueOf(Math.random()*1000000).setScale(0)+'web@gmail.com';
        insert contact;
        return contact;
    }

    public static Pricebook2 createPricebook(){
        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.Name = 'Pb teste';
        // pb.Empresa__c = 'Salvabras';
        // pb.ICMS_Simples__c = '18%';
        insert pb;
        return pb;
    }

    public static PricebookEntry createPricebookEntry(Pricebook2 pb, Product2 product2){
        PricebookEntry pbeDefault = new PricebookEntry();
        pbeDefault.IsActive = true;
        pbeDefault.Product2Id = product2.Id;
        pbeDefault.Pricebook2Id = Test.getStandardPricebookId();
        pbeDefault.UnitPrice = 1000;
        insert pbeDefault;

        PricebookEntry pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Product2Id = product2.Id;
        pbe.Pricebook2Id = pb.Id;
        pbe.UnitPrice = 1000;
        insert pbe;
        return pbe;
    }

    // public static FilialFaturamento__c createFilialFaturamento(){
        // FilialFaturamento__c filialFaturamento = new FilialFaturamento__c();
        // filialFaturamento.Name = 'Filail teste';
        // filialFaturamento.CNPJ__c = '25.894.567/0001-80';
        // filialFaturamento.UF__c = 'SC';
        // filialFaturamento.CodigoFilialERP__c = '02';
        // filialFaturamento.CodigoEmpresaERP__c = '09';
        // filialFaturamento.CodigoERP__c = '0802';
        // insert filialFaturamento;
        // return filialFaturamento;
    // }

    public static Opportunity createOpportunity(Account acc, Contact contact, Pricebook2 pb){
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.CloseDate = System.today().addDays(5);
        opp.ContactId = contact.Id;
        opp.Pricebook2Id = pb.Id;
        opp.Name = 'opp teste';
        opp.StageName = 'F3 - Negociação';
        insert opp;
        return opp;
    }

    public static OpportunityLineItem createOpportunityLineItem(Opportunity opportunity, PricebookEntry pricebookEntry){
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.OpportunityId = opportunity.Id;
        opportunityLineItem.PricebookEntryId = pricebookEntry.Id;
        opportunityLineItem.Quantity = 1090;
        opportunityLineItem.UnitPrice = pricebookEntry.UnitPrice;
        insert opportunityLineItem;
        return opportunityLineItem;
    }

    public static Order createOrder(
            Account acc,
            Opportunity opportunity,
            Pricebook2 pricebook2,
            // FilialFaturamento__c filialFaturamento,
            Account transportadora,
            String condicaoPagamento,
            Account vendedor){
        Order order = new Order();
        // order.Vendedor__c = vendedor.Id;
        // order.CondicaoPagamento__c = condicaoPagamento.Id;
        // order.FilialFaturamento__c = filialFaturamento.Id;
        // order.Transportadora__c = transportadora.Id;
        order.OpportunityId = opportunity.Id;
        order.AccountId = acc.Id;
        order.Pricebook2Id = pricebook2.Id;
        order.Status = 'Rascunho';
        // order.TipoFrete__c = 'CIF';
        order.EffectiveDate = System.today();
        // order.Natureza__c = '6101';
        // order.ObservacoesNotaFiscal__c = 'Pedido do cliente: 10000';
        order.Type = 'N';
        // order.UnidadeMedida__c = 'UNIDADE';
        insert order;
        return order;
    }

    public static OrderItem createOrderItem(Order order, OpportunityLineItem opportunityLineItem){
        OrderItem orderItem = new OrderItem();
        orderItem.OrderId = order.Id;
        orderItem.PricebookEntryId = opportunityLineItem.PricebookEntryId;
        orderItem.Quantity = opportunityLineItem.Quantity;
        orderItem.UnitPrice = opportunityLineItem.UnitPrice;
        insert orderItem;
        return orderItem;
    }

    public static Product2 createProduct(){
        Product2 product2 = new Product2();
        product2.Name = 'produto teste';
        // product2.CodigoERP__C = 'oppteste';
        // product2.Altura__c = 4;
        // product2.Calculo_IPI__c = 2;
        // product2.Comprimento__c = 100;
        // product2.Custo_de_Produto_Bras__c = 22.19;
        // product2.Custo_de_Produto_Pro__c = 0;
        product2.Description = 'Proteção pra embagens';
        // product2.Embalagem_Master__c = 'Unitário';
        product2.Family = 'protecao_pisos';
        product2.IsActive = true;
        // product2.IPI__c = 3;
        // product2.Largura__c = 0;
        // product2.Metragem__c = 0;
        product2.Name = 'Salva Embalagem 1,00m x 15m';
        // product2.NCM__c = 48115129;
        // product2.Peso_KG__c = 2.55;
        product2.ProductCode = 'P0233';
    //    product2.Tipo_de_produto__c = 'Papelão ondulado';
        insert product2;
        return product2;
    }

    public static PricebookEntry createPricebookEntryStandard(Product2 product2){
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.Product2Id = product2.Id;
        pbe.UnitPrice = 1000;
        pbe.IsActive = true;
        insert pbe;
        return pbe;
    }

    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
}