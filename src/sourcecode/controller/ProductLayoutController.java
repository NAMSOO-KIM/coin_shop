package sourcecode.controller;

import java.net.URL;

import java.util.List;
import java.util.ResourceBundle;

import com.jfoenix.controls.JFXComboBox;
import java.util.ArrayList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TextField;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonBar;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseEvent;

import org.controlsfx.control.textfield.AutoCompletionBinding;
import org.controlsfx.control.textfield.TextFields;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import sourcecode.MainApp;

import sourcecode.model.Person;

public class ProductLayoutController implements Initializable {

    @FXML private JFXComboBox<String> attributeList;
    @FXML private TextField txtSearch;
    @FXML private TableView<Person> productTable;
    @FXML private TableColumn<Person, String> columnImage;
    @FXML private TableColumn<Person, String> columnProductName;
    @FXML private TableColumn<Person, String> columnPrice;
    @FXML private TableColumn<Person, String> columnSellerName;
    @FXML private TableColumn<Person, String> columnCategory; 
    @FXML private TableColumn<Person, String> columnProductStatus; 
    @FXML private Label lblNote;  
    @FXML private Label lblError;
    
    private List<Person> listPerson = new ArrayList();
    
    private ObservableList<Person> observableListPerson;
    
    MainApp mainApp;
   
    
    @FXML
    void actionRegisterProduct(ActionEvent event) {
    	mainApp.showRegisterProductDialog();
    }

   
    
    @FXML
    void actionSearch(ActionEvent event) {
        try{
            if (attributeList.getValue().equals("Show everyone")){
            	loadProduct(true);
            }else{
                
                List<Person> people = new ArrayList();
                
                switch (attributeList.getValue()) {
                    case "물품명":
                        //people.add(DAO.getInstance().findById(Integer.parseInt(txtSearch.getText())));
                        break;
                    case "카테고리":
                        //people = DAO.getInstance().findByName(txtSearch.getText());
                        break; 
                    case "판매금액":
                        //people = DAO.getInstance().findByAddress(txtSearch.getText()); 
                        break;
                    default:
                        break;
                }

                loadProduct(people);
            }
        }catch(NumberFormatException ime){
            lblError.setText("Enter the valid value type");
        }catch(NullPointerException npe){
            lblError.setText("Enter some value");
        }
    }
    
    @FXML
    void keyPressed(KeyEvent event) {
        lblError.setText("");
            
    }
    
    @FXML
    void actionCombobox(ActionEvent event) {
        if (attributeList.getValue().equals("Show everyone")){
            loadProduct(true);
        }
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        
    	loadProduct(false);
        loadCombobox();
        
		/*
		 * try{ productTable.getSelectionModel().selectedItemProperty().addListener(
		 * (observable, oldValue, newValue) -> showNote(newValue));
		 * 
		 * //loadAutoComplete();
		 * 
		 * }catch(NullPointerException npe){ lblNote.setText(""); }
		 */
    }    
    
    @FXML
    private void onClickedTable(MouseEvent event) {
    	//productTable.getSelectionModel().getSelectedItem().getXX();
    	mainApp.showBuyProductDialog();
    }
    
    public boolean loadProduct(boolean cleanTable){
        
        try {
            if(cleanTable) {
                cleanTable();
            }
            
            definingColumn();
        
            //setListPerson(DAO.getInstance().findAll());

            observableListPerson = FXCollections.observableArrayList(listPerson);
            productTable.setItems(observableListPerson);
            
        }catch(Exception e) {
            alert("Error", null, "An error occurred while retrieving data", Alert.AlertType.ERROR);
            return false;
        }
        
        return true;
    }
    
    
    public void loadProduct(List<Person> arrayListPerson) {
         try {
            cleanTable();
            observableListPerson = FXCollections.observableArrayList(arrayListPerson);
            productTable.setItems(observableListPerson);
        }catch(Exception e) {
            alert("Error", null, "An error occurred while retrieving data", Alert.AlertType.ERROR);
        }
    }
    
    public void definingColumn() {
        columnImage.setCellValueFactory(new PropertyValueFactory<>("image"));
        columnProductName.setCellValueFactory(new PropertyValueFactory<>("productName"));
        columnPrice.setCellValueFactory(new PropertyValueFactory<>("price"));
        columnSellerName.setCellValueFactory(new PropertyValueFactory<>("sellerName"));
        columnCategory.setCellValueFactory(new PropertyValueFactory<>("category"));
        columnProductStatus.setCellValueFactory(new PropertyValueFactory<>("status"));
    }

    private void cleanTable() {
        productTable.getItems().clear();
    }
    
    private void alert(String titulo, String headerText, String contentText, Alert.AlertType type){
        Alert alert = new Alert(type);
        alert.setTitle(titulo);
        alert.setHeaderText(headerText);
        alert.setContentText(contentText);
        alert.showAndWait();
    }
    
    public void loadCombobox() {
        
        List<String> values = new ArrayList<String>();
     
        values.add("물품명");
        values.add("카테고리");
        values.add("판매금액");
        
        ObservableList<String> obsValues = FXCollections.observableArrayList(values);
        attributeList.setItems(obsValues);
    }
    

    public void loadAutoComplete() {
        
        // Variables for autosuggestion :)
        AutoCompletionBinding<String> acb;
        Set<String> ps;
        
        ArrayList<String> values = new ArrayList<String>();
        for (int i = 0; i < listPerson.size(); i++){
            values.add(listPerson.get(i).getName());
            values.add(listPerson.get(i).getAddress());
            values.add(listPerson.get(i).getEmail());
            values.add(listPerson.get(i).getBirthday());
            values.add(listPerson.get(i).getNumber());
        }
        
        
        String[] _possibleSuggestions = values.toArray(new String[0]);
        ps = new HashSet<>(Arrays.asList(_possibleSuggestions));
        TextFields.bindAutoCompletion(txtSearch, _possibleSuggestions);
    }
    
    public void showNote(Person person) {
        lblNote.setText(person.getNote());
    }
    
    public List<Person> getListPerson() {
        return listPerson;
    }

    public void setListPerson(List<Person> listPerson) {
        this.listPerson = listPerson;
    }
    
    
    public MainApp getMainApp() {
        return mainApp;
    }

    public void setMainApp(MainApp mainApp) {
        this.mainApp = mainApp;
    }
   
}