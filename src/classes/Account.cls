/**
 * @author Henrique Nitatori
 **/

public class Account {
    AccountRepository accountRepository;
   
    public Account(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }   


    public void createNewAccount(String clientFirstName, String clientLastName, String clientDocument) {
        if(String.isBlank(clientFirstName) || String.isBlank(clientLastName) || String.isBlank(clientDocument)) {return;}

        List<Account__c> accounts = new List<Account__c>{
            new Account__c(
            clientFirstName__c = clientFirstName,
            clientLastName__c = clientLastName,
            clientDocument__c = clientDocument,
            balance__c = 0)
        };

        this.accountRepository.create(accounts);
    }
}