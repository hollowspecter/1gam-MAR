package de.blogspot.hollowspecter.test;

/**
 * The car has Seats. It has a certain capacity, and for each seat
 * it can hold one human. Adds new humans to the beginning of the array
 * and pops them out of the end of the array.
 * @author Vivien Baguio
 */
class Seats
{
	private var _seats : Array<Int>;
	private var _occupied : Bool;
	private var _capacity(getCapacity,setCapacity) : Int;
	
	public function new(_capacity:Int) 
	{
		this._capacity = capacity;
		this._occupied = false;
		_seats = new Array<Int>;
	}
	
	/**
	 * Adds the id of the human who will occupy the seat
	 * @param	id is id of the human who will occupy the seat
	 * @return	returns false when all seats are occupied!
	 */
	public function add(id:Int):Bool
	{
		if (!_seats.length >= _capacity)
		{
			_seats.insert(0, id);
			_occupied = true;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * Removes in a fifo way the passenger who waited the longest.
	 * @return
	 */
	public function remove():Int
	{
		if (_seats.length == 1)
			_occupied = false;
		return _seats.pop();
	}
	
	public function getCapacity():Int
	{
		return _capacity;
	}
	
	public function setCapacity(cap:Int)
	{
		if (cap < 1)
			_capacity = 1;
		else if (cap > 3)
			_capacity = 3;
		else
			_capacity = cap;
	}
}