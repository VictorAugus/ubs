public class CustomLoginController {
    public String username{get;set;}
    public String password{get;set;}
    public PageReference doLogin(){
        return Site.login('v.pecuch_comunidade@daspeweb.com.br','Daspe@2027','/s/dashboard/01Z6e000000NPB0/testepainel');
    }
}