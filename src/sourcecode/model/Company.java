package sourcecode.model;

public class Company<K, V> {
	private K key;
	private V value;
	
	public K getCompanyID() {
		return key;
	}
	
	public V getCompanyName() {
		return value;
	}
	
	public void setCompany(K k, V v) {
		this.key = k;
		this.value = v;
	}
}
