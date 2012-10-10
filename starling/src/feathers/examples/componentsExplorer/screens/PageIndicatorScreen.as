package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PageIndicator;
	import feathers.controls.Screen;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	public class PageIndicatorScreen extends Screen
	{
		public function PageIndicatorScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _pageIndicator:PageIndicator;

		private var _onBack:Signal = new Signal(PageIndicatorScreen);

		public function get onBack():ISignal
		{
			return this._onBack;
		}

		override protected function initialize():void
		{
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.pageCount = 5;
			this.addChild(this._pageIndicator);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.onRelease.add(backButton_onRelease);

			this._header = new Header();
			this._header.title = "Page Indicator";
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

			this._pageIndicator.width = this.actualWidth;
			this._pageIndicator.validate();
			this._pageIndicator.y = this._header.height + (this.actualHeight - this._header.height - this._pageIndicator.height) / 2;
		}

		private function onBackButton():void
		{
			this._onBack.dispatch(this);
		}

		private function backButton_onRelease(button:Button):void
		{
			this.onBackButton();
		}
	}
}
