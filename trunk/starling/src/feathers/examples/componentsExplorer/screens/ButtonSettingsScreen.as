package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.Header;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.examples.componentsExplorer.data.ButtonSettings;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	public class ButtonSettingsScreen extends Screen
	{
		public function ButtonSettingsScreen()
		{
		}

		public var settings:ButtonSettings;

		private var _header:Header;
		private var _list:List;
		private var _backButton:Button;

		private var _isToggleToggle:ToggleSwitch;
		private var _horizontalAlignPicker:PickerList;
		private var _verticalAlignPicker:PickerList;
		private var _iconToggle:ToggleSwitch;
		private var _iconPositionPicker:PickerList;
		private var _iconOffsetXSlider:Slider;
		private var _iconOffsetYSlider:Slider;

		private var _onBack:Signal = new Signal(ButtonSettingsScreen);

		public function get onBack():ISignal
		{
			return this._onBack;
		}

		override protected function initialize():void
		{
			this._isToggleToggle = new ToggleSwitch();
			this._isToggleToggle.isSelected = this.settings.isToggle;
			this._isToggleToggle.onChange.add(isToggleToggle_onChange);

			this._horizontalAlignPicker = new PickerList();
			this._horizontalAlignPicker.typicalItem = Button.HORIZONTAL_ALIGN_CENTER;
			this._horizontalAlignPicker.dataProvider = new ListCollection(new <String>
			[
				Button.HORIZONTAL_ALIGN_LEFT,
				Button.HORIZONTAL_ALIGN_CENTER,
				Button.HORIZONTAL_ALIGN_RIGHT
			]);
			this._horizontalAlignPicker.listProperties.typicalItem = Button.HORIZONTAL_ALIGN_CENTER;
			this._horizontalAlignPicker.selectedItem = this.settings.horizontalAlign;
			this._horizontalAlignPicker.onChange.add(horizontalAlignPicker_onChange);

			this._verticalAlignPicker = new PickerList();
			this._verticalAlignPicker.typicalItem = Button.VERTICAL_ALIGN_BOTTOM;
			this._verticalAlignPicker.dataProvider = new ListCollection(new <String>
			[
				Button.VERTICAL_ALIGN_TOP,
				Button.VERTICAL_ALIGN_MIDDLE,
				Button.VERTICAL_ALIGN_BOTTOM
			]);
			this._verticalAlignPicker.listProperties.typicalItem = Button.VERTICAL_ALIGN_BOTTOM;
			this._verticalAlignPicker.selectedItem = this.settings.verticalAlign;
			this._verticalAlignPicker.onChange.add(verticalAlignPicker_onChange);

			this._iconToggle = new ToggleSwitch();
			this._iconToggle.isSelected = true;
			this._iconToggle.onChange.add(iconToggle_onChange);

			this._iconPositionPicker = new PickerList();
			this._iconPositionPicker.typicalItem = Button.ICON_POSITION_RIGHT_BASELINE;
			this._iconPositionPicker.dataProvider = new ListCollection(new <String>
			[
				Button.ICON_POSITION_TOP,
				Button.ICON_POSITION_RIGHT,
				Button.ICON_POSITION_RIGHT_BASELINE,
				Button.ICON_POSITION_BOTTOM,
				Button.ICON_POSITION_LEFT,
				Button.ICON_POSITION_LEFT_BASELINE,
				Button.ICON_POSITION_MANUAL
			]);
			this._iconPositionPicker.listProperties.typicalItem = Button.ICON_POSITION_RIGHT_BASELINE;
			this._iconPositionPicker.selectedItem = this.settings.iconPosition;
			this._iconPositionPicker.onChange.add(iconPositionPicker_onChange);

			this._iconOffsetXSlider = new Slider();
			//there is no actual limit. these are aribitrary.
			this._iconOffsetXSlider.minimum = -50;
			this._iconOffsetXSlider.maximum = 50;
			this._iconOffsetXSlider.step = 1;
			this._iconOffsetXSlider.value = this.settings.iconOffsetX;
			this._iconOffsetXSlider.onChange.add(iconOffsetXSlider_onChange);

			this._iconOffsetYSlider = new Slider();
			this._iconOffsetYSlider.minimum = -50;
			this._iconOffsetYSlider.maximum = 50;
			this._iconOffsetYSlider.step = 1;
			this._iconOffsetYSlider.value = this.settings.iconOffsetY;
			this._iconOffsetYSlider.onChange.add(iconOffsetYSlider_onChange);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "isToggle", accessory: this._isToggleToggle },
				{ label: "horizontalAlign", accessory: this._horizontalAlignPicker },
				{ label: "verticalAlign", accessory: this._verticalAlignPicker },
				{ label: "icon", accessory: this._iconToggle },
				{ label: "iconPosition", accessory: this._iconPositionPicker },
				{ label: "iconOffsetX", accessory: this._iconOffsetXSlider },
				{ label: "iconOffsetY", accessory: this._iconOffsetYSlider }
			]);
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new Header();
			this._header.title = "Button Settings";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this.backButtonHandler = this.onBackButton;
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
		}

		private function onBackButton():void
		{
			this._onBack.dispatch(this);
		}

		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}

		private function isToggleToggle_onChange(toggle:ToggleSwitch):void
		{
			this.settings.isToggle = this._isToggleToggle.isSelected;
		}

		private function horizontalAlignPicker_onChange(picker:PickerList):void
		{
			this.settings.horizontalAlign = this._horizontalAlignPicker.selectedItem as String;
		}

		private function verticalAlignPicker_onChange(picker:PickerList):void
		{
			this.settings.verticalAlign = this._verticalAlignPicker.selectedItem as String;
		}

		private function iconToggle_onChange(toggle:ToggleSwitch):void
		{
			this.settings.hasIcon = this._iconToggle.isSelected;
		}

		private function iconPositionPicker_onChange(picker:PickerList):void
		{
			this.settings.iconPosition = this._iconPositionPicker.selectedItem as String;
		}

		private function iconOffsetXSlider_onChange(slider:Slider):void
		{
			this.settings.iconOffsetX = this._iconOffsetXSlider.value;
		}

		private function iconOffsetYSlider_onChange(slider:Slider):void
		{
			this.settings.iconOffsetY = this._iconOffsetYSlider.value;
		}
	}
}
