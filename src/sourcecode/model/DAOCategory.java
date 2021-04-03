package sourcecode.model;

import java.sql.Connection;
import java.util.ArrayList;
import antlr.collections.List;

import sourcecode.controller.DBConnection;

public class DAOCategory {
	static DAOCategory instance;
	private ArrayList<Category<Integer, String>> categorys;
	//private static ArrayList<Category<Integer, String>> categorys;
	
	private Connection conn = DBConnection.getConnection(); 
	
	private DAOCategory() {
		categorys = new ArrayList<Category<Integer, String>>();
	}
	
	public static DAOCategory getInstance() {
		if(instance != null)
			return instance;
		else {
			instance = new DAOCategory();
			return instance;
		}
	}
	
	public void addCategory(Category<Integer, String> category) {
		categorys.add(category);
	}
		
	public Category<Integer, String> getCategory(int i) {
		int length = categorys.size();
		if(i >= length) 
			return null;
		else
			return categorys.get(i);
	}
	
	public int getCategorySize() {
		return categorys.size();
	}
	
}
