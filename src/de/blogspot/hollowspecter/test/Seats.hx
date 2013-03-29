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
	private var _capacity : Int;
		
	/**
	 * Create seatings for the car
	 * @param	_capacity Capacity of the car. Minimum 1, Maximum 3
	 */
	public function new(cap:Int) 
	{
		setCapacity(cap);
		this._occupied = false;
		_seats = new Array<Int>();
	}
	
	/**
	 * Returns you the ID of the human which waits the longest right now!
	 * @return Returns 0 when noone sits in the car
	 */
	public function getCurrentID():Int
	{
		//check if someone sits in the car
		if (_seats.length == 0)
			return 0;
		
		return _seats[_seats.length-1];
	}
	
	/**
	 * Adds the id of the human who will occupy the seat
	 * @param	id is id of the human who will occupy the seat
	 * @return	returns false when all seats are occupied!
	 */
	public function add(id:Int):Bool
	{
		var foo:Bool = false;
		if (_seats.length < _capacity && !_occupied)
		{
			_seats.insert(0, id);
			foo = true;
		}
		if (_seats.length == _capacity)
		{
			_occupied = true;
			foo = false;
		}
		return foo;
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
	
	/**
	 *  returns capacity
	 * @return returns capacity of the seatings
	 */
	public function getCapacity():Int
	{
		return _capacity;
	}
	
	/**
	 * Sets the capacity.
	 * @param	cap Capacity of the seats, how many people it can hold
	 */
	public function setCapacity(cap:Int)
	{
		if (cap < 1)
			_capacity = 1;
		else if (cap > 3)
			_capacity = 3;
		else
			_capacity = cap;
	}
	
	public function toString():String
	{
		return "occupied " + _occupied + ", " + _seats[0] + _seats[1] + _seats[2];
	}
	
	//getter setter für occupied
	public function getOccupied():Bool
	{
		return _occupied;
	}
	public function setOccupied(oc:Bool)
	{
		_occupied = oc;
	}
}