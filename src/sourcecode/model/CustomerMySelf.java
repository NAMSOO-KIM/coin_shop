package sourcecode.model;



import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Persistence;
import javax.persistence.Query;

import sourcecode.controller.DBConnection;
import sourcecode.model.Customer;

public class CustomerMySelf {
    
    private static CustomerMySelf instance;
    private Customer mine;
    
    private Connection conn = DBConnection.getConnection();   
    
    public static CustomerMySelf getInstance(){
        if (instance == null){
            instance = new CustomerMySelf();
        }
        
        return instance;
    }
    
    private CustomerMySelf(){
    	mine = new Customer();
    }

    public Customer getCustomer() {
    	if(mine == null)
    		mine = new Customer();
    	return mine;
    }
    
    public void setCustomer(Customer customer) {
    	mine = customer;
    }
    
    
}