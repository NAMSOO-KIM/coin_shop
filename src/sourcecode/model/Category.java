package sourcecode.model;

public class Category<K, V> {
	private K key;
	private V value;
	
	public K getCategoryID() {
		return key;
	}
	
	public V getCategoryName() {
		return value;
	}
	
	public void setCategory(K k, V v) {
		this.key = k;
		this.value = v;
	}
}
