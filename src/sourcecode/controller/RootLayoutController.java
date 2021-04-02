package sourcecode.controller;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

import com.jfoenix.controls.JFXButton;

import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Pane;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.stage.StageStyle;
import sourcecode.MainApp;
import sourcecode.model.DAO;

public class RootLayoutController implements Initializable {
    
    MainApp mainApp;
    Stage currentStage;
    
   
    @FXML private JFXButton btnAllProduct;
    @FXML private JFXButton btnMyProduct;
    @FXML private JFXButton btnRank;
    
    @FXML private AnchorPane paneSegment;
    private AnchorPane paneAllProduct;
    private AnchorPane paneMyProduct;
    private AnchorPane paneRankChart;
    
    private Stage[] stageData;
    private AnchorPane layoutData[];
    private Scene[] sceneData;
    private FXMLLoader[] fxmlLoader;
    
    private ProductLayoutController allProductController;
    private MyProductLayoutController myProductController;
    private RankChartLayoutController rankChartController;
   
    static final private int segment = 3;
    static final private String[] fxmlPath = {"view/fxml/ProductLayout.fxml"
    		, "view/fxml/MyProductLayout.fxml"
    		, "view/fxml/RankChartLayout.fxml"};
    
    
    @FXML
    private void OnBtnClickedAllProduct(ActionEvent event) {
    	paneAllProduct.toFront();
    	System.out.println("AllProduct");
    }
    
    @FXML
    private void onBtnClickedMyProduct(ActionEvent event) {
    	paneMyProduct.toFront();
    	System.out.println("MyProduct");
    }
    
    @FXML
    private void onClickedRankChart(ActionEvent event) {
    	paneRankChart.toFront();
    	System.out.println("RankChart");
    }
 
    
    @FXML
    void closeApplication(MouseEvent event) {
        try{
            DAO.getInstance().closeEntityManager();
        }catch(Exception e){
            System.out.println("Error when closing the application");
        }finally {
        	System.exit(0);
        }
    }
    
    
    /*
     * modeless dialog
     * create allproduct
     * create myproduct
     * create rankchart
	*/
    @Override
    public void initialize(URL url, ResourceBundle rb) {  	
    	
    }    
    public void createSegment() {
    	fxmlLoader = new FXMLLoader[segment];
    	
    	/*
    	stageData = new Stage[segment];
    	for(int i=0; i<stageData.length; i++) {
    		stageData[i] = new Stage(StageStyle.UNDECORATED);
    		stageData[i].initOwner(currentStage);
    	}
    	*/
    	//layoutData = new AnchorPane[segment];
    	
    	for(int i=0; i<segment; i++) {
    		try {
    			String strFXMLPath = fxmlPath[i];
    			fxmlLoader[i] = new FXMLLoader();
    			
    			fxmlLoader[i].setLocation(MainApp.class.getResource(strFXMLPath));
				//layoutData[i] = fxmlLoader[i].load();
				//rootLayout.setCenter(layoutData[i])
				switch(i) {
				case 0:
					paneAllProduct = fxmlLoader[i].load();
					allProductController = fxmlLoader[i].getController();
					allProductController.setMainApp(mainApp);
					break;
				case 1:
					paneMyProduct = fxmlLoader[i].load();
					myProductController = fxmlLoader[i].getController();
					myProductController.setMainApp(mainApp);
					break;
				case 2:
					paneRankChart = fxmlLoader[i].load();
					rankChartController = fxmlLoader[i].getController();
					break;
				default :
					break;
				}
    		} catch (IOException e) {
				e.printStackTrace();
			}  
    	}
    	
    	paneSegment.getChildren().add(paneAllProduct);
    	paneSegment.getChildren().add(paneMyProduct);
    	paneSegment.getChildren().add(paneRankChart);
    	//paneSegment.toBack();
    	
    }
    
    @FXML
    private void onBtnClickedCheckPoint(ActionEvent event) {
    	System.out.println("내마일리지 확인");
    }
    
    public MainApp getMainApp() {
        return mainApp;
    }

    public void setMainApp(MainApp mainApp) {
        this.mainApp = mainApp;
    }
    
    public void setDialogStage(Stage dialog) {
    	this.currentStage = dialog;
    }
}
