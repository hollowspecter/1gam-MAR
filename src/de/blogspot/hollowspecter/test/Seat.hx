package de.blogspot.hollowspecter.test;

/**
 * The car has Seats. It has a certain capacity, and for each seat
 * it can hold one human.
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