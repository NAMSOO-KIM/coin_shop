package sourcecode.model;
import java.sql.Connection;
import java.util.ArrayList;

import sourcecode.controller.DBConnection;

public class DAOCompany {
	static DAOCompany instance;
	private ArrayList<Company<Integer, String>> companys;
	
	private Connection conn = DBConnection.getConnection(); 
	
	private DAOCompany() {
		companys = new ArrayList<Company<Integer, String>>();
	}
	
	public static DAOCompany getInstance() {
		if(instance == null) {
			instance = new DAOCompany();
			return instance;
		}
		else return instance;
	}
	
	
	public void addCompany(Company<Integer, String> company) {
		companys.add(company);
	}
	
	public int getCompanySize() {
	      return companys.size();
	}
	
	public Company<Integer, String> getCompany(int i) {
		int length = companys.size();
		if(i >= length) 
			return null;
		else
			return companys.get(i);
	}
	
}
