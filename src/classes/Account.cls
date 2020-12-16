/**
 * @author Henrique Nitatori
 **/

public class Account {

    AccountRepository accountRepository;

    public Account() {
        this.accountRepository = new AccountRepository();
    }   


    public void createNewAccount(String clientFirstName, String clientLastName, String clientDocument) {
        if(String.isEmpty(clientFirstName) || String.isEmpty(clientLastName) || String.isEmpty(clientDocument)) {return;}

        List<Account__c> accountsAlreadyExists = this.accountRepository.findByDocument(clientDocument);

        if(!accountsAlreadyExists.isEmpty()) {return; }

        List<Account__c> accounts = new List<Account__c>{
            new Account__c(
            clientFirstName__c = clientFirstName,
            clientLastName__c = clientLastName,
            clientDocument__c = clientDocument,
            balance__c = 0)
        };

        this.accountRepository.create(accounts);
    }

    public void deleteAccount(String clientDocument) {
        List<Account__c> accounts = this.accountRepository.findByDocument(clientDocument);

        if(accounts.isEmpty()) {return;}

        this.accountRepository.deleteAccount(accounts);
    }

    public Boolean depositMoneyInAccount(String clientDocument, Decimal amount) {
        if(String.isEmpty(clientDocument)) {return false;}

        List<Account__c> accounts = this.accountRepository.findByDocument(clientDocument);

        if(accounts.isEmpty()) {return false;}

        List<Account__c> accountsUpdatedBalance = new List<Account__c>();

        
        Account__c accountUpdatedBalance = accounts[0].clone(true, true, true, true);
        accountUpdatedBalance.balance__c += amount;
        accountsUpdatedBalance.add(accountUpdatedBalance);
        

        this.accountRepository.store(accountsUpdatedBalance);

        return true;
    }

    public Boolean withdrawMoneyOfAccount(String clientDocument, Decimal amount) {
        if(String.isEmpty(clientDocument)) {return false;}

        List<Account__c> accounts = this.accountRepository.findByDocument(clientDocument);

        if(accounts.isEmpty()) {return false;}

        List<Account__c> accountsUpdatedBalance = new List<Account__c>();

        if(accounts[0].balance__c < amount) {
            accounts[0].addError('balance__c', 'Saldo insuficiente');
        }

        Account__c accountUpdatedBalance = accounts[0].clone(true, true, true, true);
        accountUpdatedBalance.balance__c -= amount;
        accountsUpdatedBalance.add(accountUpdatedBalance);
        

        this.accountRepository.store(accountsUpdatedBalance);
        return true;
    }

    public void transferMoneyOfAccount(String documentOfSender, String documentOfReceiver, Decimal amount) {
        if( withdrawMoneyOfAccount(documentOfSender, amount) ) {

           if( depositMoneyInAccount(documentOfReceiver, amount) ) {return;}

           depositMoneyInAccount(documentOfSender, amount);
        }
    }
}