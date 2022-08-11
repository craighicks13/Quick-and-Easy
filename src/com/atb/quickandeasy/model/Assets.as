package com.atb.quickandeasy.model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public final class Assets
	{
		/**
		 * SD Assets
		 **/
		
		[Embed(source="../assets/dashbackground.png")]
		public static const DashBackground:Class;
		
		[Embed(source="../assets/additionalbackground.png")]
		public static const AdditionalBackground:Class;
		
		[Embed(source="../assets/approvalbackground.png")]
		public static const ApprovalBackground:Class;
		
		[Embed(source="../assets/spritesheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXML:Class;
		
		[Embed(source="../assets/spritesheet.png")]
		public static const AtlasTexture:Class;
		
		/**
		 * Bitmap Font
		 **/
		
		[Embed(source="../assets/ModeSeven.fnt", mimeType="application/octet-stream")]
		public static const ModeSevenXML:Class;
		
		[Embed(source="../assets/ModeSeven.png")]
		public static const ModeSeven:Class;
		
		/**
		 * Sounds
		 **/
		
		[Embed(source="../assets/audio/01enterLoanAbount.mp3")]
		private static var EnterLoanAmountSound:Class;
		public static var enterLoanSound:Sound;
		
		[Embed(source="../assets/audio/03amoritizationtick.mp3")]
		private static var AmortizationTickSound:Class;
		public static var amortizationSound:Sound;
		
		[Embed(source="../assets/audio/03amortization.mp3")]
		private static var AmortizationLockSound:Class;
		public static var amortizationLockSound:Sound;
		
		[Embed(source="../assets/audio/04termV2.mp3")]
		private static var TermOfLoanSound:Class;
		public static var termSound:Sound;
		
		[Embed(source="../assets/audio/06fixedVariable.mp3")]
		private static var FixedVariableSound:Class;
		public static var fixedSound:Sound;
		
		[Embed(source="../assets/audio/07paymentFrequency.mp3")]
		private static var PaymentFrequencySound:Class;
		public static var frequencySound:Sound;
		
		[Embed(source="../assets/audio/08tractor.mp3")]
		private static var StartUpSound:Class;
		public static var startSound:Sound;
		
		[Embed(source="../assets/audio/send-button-sound.mp3")]
		private static var SubmitButtonSound:Class;
		public static var submitSound:Sound;
		
		public static var scale:Number = 1;
		
		private static var sTextures:Dictionary = new Dictionary();
		private static var sTextureAtlas:TextureAtlas;
		
		public static function init():void
		{
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new ModeSeven()), XML(new ModeSevenXML())));
			
			enterLoanSound = new EnterLoanAmountSound();
			enterLoanSound.play(0, 0, new SoundTransform(0));
			
			amortizationLockSound = new AmortizationLockSound();
			amortizationLockSound.play(0, 0, new SoundTransform(0));
			
			amortizationSound = new AmortizationTickSound();
			amortizationSound.play(0, 0, new SoundTransform(0));
			
			termSound = new TermOfLoanSound();
			termSound.play(0, 0, new SoundTransform(0));
			
			fixedSound = new FixedVariableSound();
			fixedSound.play(0, 0, new SoundTransform(0));
			
			frequencySound = new PaymentFrequencySound();
			frequencySound.play(0, 0, new SoundTransform(0));
			
			startSound = new StartUpSound();
			startSound.play(0, 0, new SoundTransform(0));
			
			submitSound = new SubmitButtonSound();
			submitSound.play(0, 0, new SoundTransform(0));
			
			Assets.getTexture('AdditionalBackground');
			Assets.getTexture('ApprovalBackground');
		}
		
		public static function getBitmapData(name:String):BitmapData
		{
			if (sTextures[name] == undefined)
			{
				var data:Bitmap = Bitmap(new Assets[name]());
				sTextures[name] = data.bitmapData;
			}
			
			return sTextures[name];
		}
		
		public static function getTexture(name:String):Texture
		{
			if (sTextures[name] == undefined)
			{
				var data:Object = new Assets[name]();
				if (data is Bitmap)
					sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, scale);
				else if (data is ByteArray)
					sTextures[name] = Texture.fromAtfData(data as ByteArray, scale);
			}
			
			return sTextures[name];
		}
		
		public static function getTextureAtlas():TextureAtlas
		{
			if (sTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new Assets["AtlasXML"]());
				sTextureAtlas = new TextureAtlas(texture, xml);
			}
			
			return sTextureAtlas;
		}
	}
}