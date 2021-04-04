package sourcecode.controller;

import java.net.URL;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ResourceBundle;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.Statement;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;


public class RankChartLayoutController implements Initializable {
    
    @FXML
    private BarChart<String, Integer> barChart;
    @FXML
    private CategoryAxis xAxis;
    
    @FXML
    private NumberAxis yAxis;
    
    
    
    
    
    private ObservableList<String> monthNames = FXCollections.observableArrayList();
    //private RankPerson<String,Integer> rankPerson ;
    private ObservableList<String> rankNames = FXCollections.observableArrayList();
    private ObservableList<Integer> rankScore = FXCollections.observableArrayList();
    
   
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		// TODO Auto-generated method stub
		OracleCallableStatement ocstmt = null;
		   
		   String runP = "{ call select_coinRanking(?) }";
		   try {
			   Connection conn = (Connection) DBConnection.getConnection();
			   Statement stmt = (Statement) conn.createStatement();
			   CallableStatement callableStatement = conn.prepareCall(runP.toString());
			   callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
			   callableStatement.executeUpdate();	
			   ocstmt = (OracleCallableStatement)callableStatement;

			  
			   ResultSet rs =  ocstmt.getCursor(1);
			   
			   
			   int count = 0;
			   
			   while (rs.next()) {
			        String field1 = rs.getString(1);
			        String name =rs.getString("name");
			        int coin= rs.getInt("coin");
			        rankNames.add(name);
			        rankScore.add(coin);
			        //rankname_list.add(new RankPerson(name,coin));
			    	
			        
			        //RankNames.add(name);
			        //RankScore.add(coin);
			        //RankPerson rp = new RankPerson(name,coin);
			        //rankname_list.add(rp);

			        // 10명 까지만 받기
			        if(count == 10) {
			        	break;
			        }
			        
			   }
			   
			   
			   xAxis.setCategories(rankNames);
			   
			   
			   XYChart.Series<String, Integer> series = new XYChart.Series<>();
			   
			   for (int i = 0; i < rankNames.size(); i++) {
				   series.getData().add(new XYChart.Data<>(rankNames.get(i), rankScore.get(i)));
				  
			   }
			   barChart.getData().add(series);
			   
			   //xAxis.setCategories(RankNames);
			   
			        //System.out.println(customerMyself.getCustomer().getName()+" 로그인 정보 동기화 완료");
			   //}
			   
			   
			   //yAxis = new NumberAxis();
			   
			   //yAxis.appe
			   }
			   
			   
		    catch(Exception e) {
			   e.printStackTrace();
			
		   }
	}

	
    
   
   }

    
    
    // to-do
    //private boolean procCallCustomerInfo(String strID) {
    	
    	
		   
	   
    
    //}
 

//	  public void setPersonData(List<Person> persons){
//	  
//	  int[] monthCounter = new int[12]; for (Person p: persons){ int month =
//	  DateUtil.formatDate(p.getBirthday()).getMonthValue()-1;
//	  monthCounter[month]++; }
//	  
//	  XYChart.Series<String, Integer> series = new XYChart.Series<>();
//	  
//	  for (int i = 0; i < monthCounter.length; i++) { series.getData().add(new
//	  XYChart.Data<>(monthNames.get(i), monthCounter[i])); }
//	  
//	  barChart.getData().add(series);
//	  
//	  }
    	
/*
         OracleCallableStatement ocstmt = null;
		   
		   String runP = "{ call select_coinRanking(?) }";
		   try {
			   Connection conn = DBConnection.getConnection();
			   Statement stmt = conn.createStatement();
			   CallableStatement callableStatement = conn.prepareCall(runP.toString());
			   callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
			   callableStatement.executeUpdate();	
			   ocstmt = (OracleCallableStatement)callableStatement;

			  
			   ResultSet rs =  ocstmt.getCursor(1);
			   
			   ArrayList<RankPerson> rankname_list= new ArrayList<>();
			   
			   while (rs.next()) {
			        String field1 = rs.getString(1);
			        String name =rs.getString("name");
			        int coin= rs.getInt("coin");
			        
			        
			        RankNames.add(name);
			        RankScore.add(coin);
			        //RankPerson rp = new RankPerson(name,coin);
			        //rankname_list.add(rp);
			        
			        
			        //System.out.println(customerMyself.getCustomer().getName()+" 로그인 정보 동기화 완료");
			   }
			   
			   xAxis.setCategories(RankNames);
			   //yAxis = new NumberAxis();
			   
			   //yAxis.appe
			   }
			   
			   
		    catch(Exception e) {
			   e.printStackTrace();
			
		   }
 */

    
    
    
    
    
    
