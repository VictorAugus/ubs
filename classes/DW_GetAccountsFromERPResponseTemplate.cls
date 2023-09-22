public class DW_GetAccountsFromERPResponseTemplate {
    public Integer page;
    public Integer pageSize;
    public Integer count;
    public Integer pageCount;
    public Boolean hasNext;
    public List<DW_ClienteIntegrable> clientes;
    
    
    public class DW_ClienteIntegrable {
        public String Name;
        public Integer codigoERP;
        
    }
}