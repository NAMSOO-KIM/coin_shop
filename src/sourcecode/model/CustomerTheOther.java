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

public class CustomerTheOther {
    
    private static CustomerTheOther instance;
    private Customer mine;
    
    private Connection conn = DBConnection.getConnection();   
    
    public static CustomerTheOther getInstance(){
        if (instance == null){
            instance = new CustomerTheOther();
        }
        
        return instance;
    }
    
    private CustomerTheOther(){
    	mine = new Customer();
    }

    public Customer getCustomer() {
    	if(mine == null)
    		mine = new Customer();
    	return this.mine;
    }
    
    public void setCustomer(Customer customer) {
    	mine = customer;
    }
    
    
}