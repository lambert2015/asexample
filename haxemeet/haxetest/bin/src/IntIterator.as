package  {
	import flash.Boot;
	public class IntIterator {
		public function IntIterator(min : int = 0,max : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			this.min = min;
			this.max = max;
		}}
		
		public function next() : int {
			return this.min++;
		}
		
		public function hasNext() : Boolean {
			return this.min < this.max;
		}
		
		public var max : int;
		public var min : int;
	}
}
