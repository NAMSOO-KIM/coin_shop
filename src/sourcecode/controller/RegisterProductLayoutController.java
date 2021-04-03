package sourcecode.controller;

import com.jfoenix.controls.JFXComboBox;
import com.jfoenix.controls.JFXRadioButton;
import com.jfoenix.controls.JFXTextArea;
import com.jfoenix.controls.JFXTextField;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.ComboBox;
import javafx.scene.control.PasswordField;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.control.Alert.AlertType;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import sourcecode.util.SendEmail;
import sourcecode.model.CustomerMySelf;
import sourcecode.model.DAOCategory;
import sourcecode.model.DAOCompany;
import sourcecode.model.Customer;

public class RegisterProductLayoutController implements Initializable {
	Stage currentStage;
	
    @FXML private ComboBox<String> cbCategory;
    @FXML private ComboBox<String> cbShipmentCompany;
    @FXML private JFXTextField tfProductName;
    @FXML private JFXTextField tfProductPrice;
    @FXML private JFXTextField tfProductImagePath;
    @FXML private JFXTextArea tfaProductInformation;
    
    
    private String strCategory;
    private String strShipmentCompany;
    private String strProductName;
    private String strProductInformation;
    private String strProductImagePath;
    private int nProductPrice;
    
    private DAOCategory categorys;
    private DAOCompany company;
   
   
    private List<String> emails;
    
    
    @FXML
    public void onBtnClickedRegisterProductSubmit(ActionEvent event) {
    	if(isValidInput()) {
    		
    	}
    }
    
    @FXML
    public void onBtnClickedRegisterProductCancel(ActionEvent event) {
    	currentStage.close();
    }
    @FXML
    public void onBtnClickedAttachImage(ActionEvent event) {
            Stage imageStage = (Stage) ((Node)event.getSource()).getScene().getWindow();
            String attach = "";
            FileChooser fileChooser = new FileChooser();
            fileChooser.setTitle("Get Image Path");

            File file =  fileChooser.showOpenDialog(imageStage);

            if (file != null){
                
                String nameFile = "";
                char[] fileC = (file+"").toCharArray();
                for (int i = 0; i < (file+"").length(); i++){
                    if (i == 27){
                        nameFile += "...";
                        break;
                    }
                    nameFile += fileC[i];
                }
                attach = file.toString();

                tfProductImagePath.setText(nameFile.toString());
            }else{
                attach = "";
            }

    }
    
   
    
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
    	loadComboboxCategory();
    	loadComboboxShipmentCompany();
    	
    	tfProductPrice.setOnKeyPressed(event -> {
    		String productPrice = "";
    		
    		String value = event.getText();
    		try {
    			if(Character.isDigit(value.charAt(0))) {
        			return;
        		} else {
        			Alert alert = new Alert(AlertType.WARNING);
            		alert.setTitle("Warning!!");
            		alert.setHeaderText("���ڸ� �Է��ϼ���");
            		alert.showAndWait();
            		productPrice = tfProductPrice.getText();
            		productPrice = productPrice.substring(0, productPrice.length() - 1);

        		}
    		} catch(NullPointerException e) {
    			
    		} finally {
    			
    			if(productPrice.length() == 0)
    				return;
        		tfProductPrice.setText(productPrice);
    		}
    		
    	});
    }    
    
    
    public boolean isValidInput(){
        
        String errorMessage = "";
        
        if (strProductName == null) {
        	errorMessage += "Invalid product name!\n";
        }
        if (nProductPrice <= 0){
        	errorMessage += "Invalid product price!\n";
        }
        if (cbCategory.getValue() == null) {
        	errorMessage += "Invalid category name!\n";
        }
        if (cbShipmentCompany.getValue() == null){
            errorMessage += "Invalid shipment name!\n";
        }
        
        strProductName = tfProductName.getText();
        strCategory = cbCategory
        		.getSelectionModel()
        		.getSelectedItem()
        		.toString();
        
        nProductPrice = Integer.parseInt(tfProductPrice.getText());
        strShipmentCompany = cbShipmentCompany
        		.getSelectionModel()
        		.getSelectedItem()
        		.toString();
        
        strProductInformation = tfaProductInformation.getText();
        strProductImagePath = tfProductImagePath.getText();
        
        
        //��ǰ��� callablestatement

        
        if (errorMessage.length() == 0){
            return true;
        }else{
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Invalid Fields");
            alert.setHeaderText("Please, correct the fields!");
            alert.setContentText(errorMessage);
            alert.showAndWait();
            return false;
        }
    }
    
    public void clearFieldsEmail(){
        tfProductName.setText("");
        tfProductPrice.setText("");
        tfaProductInformation.setText("");
    }
    
    public void loadComboboxShipmentCompany(){
        emails = new ArrayList();
        //load from db
        //List<Person> persons = DAO.getInstance().findAll();
        
		/*
		 * if (persons != null){ for (int i = 0; i < persons.size(); i++){
		 * emails.add(persons.get(i).getEmail()); }
		 * 
		 * ObservableList<String> obsValues = FXCollections.observableArrayList(emails);
		 * cbShipmentCompany.setItems(obsValues); }
		 */
    }
    
    public void loadComboboxCategory(){
    	
        List<String> values = new ArrayList();
        //load from db
        //values.add("CJ");
     
        
        ObservableList<String> obsValues = FXCollections.observableArrayList(values);
        cbCategory.setItems(obsValues);
    }
    public void setDialogStage(Stage dialogStage) {
        this.currentStage = dialogStage;
    }
}
