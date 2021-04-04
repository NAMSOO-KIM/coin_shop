package sourcecode.controller;

import java.net.URL;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.ResourceBundle;

import com.mysql.jdbc.Connection;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.NumberAxis;
import oracle.jdbc.OracleCallableStatement;
import sourcecode.model.RankPerson;


public class RankChartLayoutController implements Initializable {
    
    @FXML
    private BarChart<String, Integer> barChart;
    @FXML
    private NumberAxis xAxis;
    
    @FXML
    private NumberAxis yAxis;
    
    
    
    
    
    private ObservableList<String> monthNames = FXCollections.observableArrayList();
    //private RankPerson<String,Integer> rankPerson ;
    private ObservableList<String> RankNames = FXCollections.observableArrayList();
    private ObservableList<Integer> RankScore = FXCollections.observableArrayList();
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // String[] months = DateFormatSymbols.getInstance(Locale.ENGLISH).getMonths();
        
    	// 회원 목록 뿌려주기 순서대로
    	
        //String[] months = {"Jan", "Feb", "Mar", "Apr", "May",
        //                   "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        
        
        //monthNames.addAll(Arrays.asList(months));
        
        xAxis(monthNames);
        
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
			        
			   }
			   
			   xAxis.setCategories(RankNames);
			   
			        //System.out.println(customerMyself.getCustomer().getName()+" 로그인 정보 동기화 완료");
			   }
			   
			   
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

    
    
    
    
    
    
