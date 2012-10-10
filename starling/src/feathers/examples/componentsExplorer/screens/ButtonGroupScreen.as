package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	public class ButtonGroupScreen extends Screen
	{
		public function ButtonGroupScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _buttonGroup:ButtonGroup;

		private var _onBack:Signal = new Signal(ButtonGroupScreen);

		public function get onBack():ISignal
		{
			return this._onBack;
		}

		override protected function initialize():void
		{
			this._buttonGroup = new ButtonGroup();
			this._buttonGroup.dataProvider = new ListCollection(
			[
				{ label: "One", onRelease: button_onRelease },
				{ label: "Two", onRelease: button_onRelease },
				{ label: "Three", onRelease: button_onRelease },
				{ label: "Four", onRelease: button_onRelease },
			]);
			this.addChild(this._buttonGroup);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new Header();
			this._header.title = "Button Group";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._buttonGroup.validate();
			this._buttonGroup.x = (this.actualWidth - this._buttonGroup.width) / 2;
			this._buttonGroup.y = this._header.height + (this.actualHeight - this._header.height - this._buttonGroup.height) / 2;
		}

		private function onBackButton():void
		{
			this._onBack.dispatch(this);
		}

		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}

		private function button_onRelease(button:Button):void
		{
			trace(button.label + " tapped.");
		}
	}
}
