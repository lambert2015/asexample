package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.skins.StandardIcons;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class MainMenuScreen extends Screen
	{
		public function MainMenuScreen()
		{
			super();
		}

		private var _header:Header;
		private var _list:List;
		
		private var _onButton:Signal = new Signal(MainMenuScreen);
		
		public function get onButton():ISignal
		{
			return this._onButton;
		}

		private var _onButtonGroup:Signal = new Signal(MainMenuScreen);

		public function get onButtonGroup():ISignal
		{
			return this._onButtonGroup;
		}

		private var _onCallout:Signal = new Signal(MainMenuScreen);

		public function get onCallout():ISignal
		{
			return this._onCallout;
		}

		private var _onScrollText:Signal = new Signal(MainMenuScreen);

		public function get onScrollText():ISignal
		{
			return this._onScrollText;
		}
		
		private var _onSlider:Signal = new Signal(MainMenuScreen);
		
		public function get onSlider():ISignal
		{
			return this._onSlider;
		}
		
		private var _onToggles:Signal = new Signal(MainMenuScreen);
		
		public function get onToggles():ISignal
		{
			return this._onToggles;
		}

		private var _onGroupedList:Signal = new Signal(MainMenuScreen);

		public function get onGroupedList():ISignal
		{
			return this._onGroupedList;
		}
		
		private var _onList:Signal = new Signal(MainMenuScreen);
		
		public function get onList():ISignal
		{
			return this._onList;
		}

		private var _onPageIndicator:Signal = new Signal(MainMenuScreen);

		public function get onPageIndicator():ISignal
		{
			return this._onPageIndicator;
		}
		
		private var _onPickerList:Signal = new Signal(MainMenuScreen);
		
		public function get onPickerList():ISignal
		{
			return this._onPickerList;
		}

		private var _onTabBar:Signal = new Signal(MainMenuScreen);

		public function get onTabBar():ISignal
		{
			return this._onTabBar;
		}

		private var _onTextInput:Signal = new Signal(MainMenuScreen);

		public function get onTextInput():ISignal
		{
			return this._onTextInput;
		}

		private var _onProgressBar:Signal = new Signal(MainMenuScreen);

		public function get onProgressBar():ISignal
		{
			return this._onProgressBar;
		}
		
		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Feathers";
			this.addChild(this._header);

			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
				{ label: "Button", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onButton },
				{ label: "Button Group", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onButtonGroup },
				{ label: "Callout", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onCallout },
				{ label: "Grouped List", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onGroupedList },
				{ label: "List", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onList },
				{ label: "Page Indicator", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onPageIndicator },
				{ label: "Picker List", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onPickerList },
				{ label: "Progress Bar", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onProgressBar },
				{ label: "Scroll Text", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onScrollText },
				{ label: "Slider", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onSlider },
				{ label: "Tab Bar", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onTabBar },
				{ label: "Text Input", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onTextInput },
				{ label: "Toggles", accessoryTexture: StandardIcons.listDrillDownAccessoryTexture, signal: this._onToggles },
			]);
			this._list.itemRendererProperties.labelField = "label";
			this._list.itemRendererProperties.accessoryTextureField = "accessoryTexture";
			this._list.onChange.add(list_onChange);
			this.addChild(this._list);
		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
		}
		
		private function list_onChange(list:List):void
		{
			const signal:Signal = Signal(this._list.selectedItem.signal);
			signal.dispatch(this);
		}
	}
}