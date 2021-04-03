package sourcecode.model;

public class Customer {

    private int intId;
    private String strName;
    private String strPassword;
    private String strZipcode;
    private String strPhone;
    private int intCoin;
    private int intVolunteer_time;
    
    public Customer(){
    
    }

    public int getId() {
        return intId;
    } 

    public void setId(int id) {
        this.intId = id;
    }

    public String getName() {
        return strName;
    }

    public void setName(String name) {
        this.strName = name;
    }
    
    public String getPassword() {
        return strPassword;
    }

    public void setPassword(String password) {
        this.strPassword = password;
    }
    
    public String getZipcode() {
        return strZipcode;
    }

    public void setZipcode(String zipcode) {
        this.strZipcode = zipcode;
    }

    public String getPhone() {
        return strPhone;
    }

    public void setPhone(String phone) {
        this.strPhone = phone;
    }

    public int getCoin() {
        return intCoin;
    }

    public void setCoin(int coin) {
        this.intCoin = coin;
    }

    public int getVolunteer_time() {
        return intVolunteer_time;
    }

    public void setVolunteer_time(int time) {
        this.intVolunteer_time = time;
        this.intCoin = time * 10;
    }
}
