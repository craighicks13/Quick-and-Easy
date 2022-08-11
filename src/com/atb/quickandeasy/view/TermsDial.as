package com.atb.quickandeasy.view
{
	import com.atb.quickandeasy.interfaces.IInteractiveElement;
	import com.atb.quickandeasy.model.Assets;
	import com.atb.quickandeasy.model.Values;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;

	public class TermsDial extends Sprite implements IInteractiveElement
	{
		protected var cursorPosStage:Point;
		protected var _value:Number = 1;
		protected var valueChanged:Boolean = true;
		protected var valueChangedByInteraction:Boolean = false;

		protected var _maxRotation:Number = 255;

		protected var maxRotationChanged:Boolean = true;

		private var _minimum:Number = 1;
		private var _maximum:Number = 10;

		protected var minimumChanged:Boolean = true;

		protected var _zeroAngle:Number = 0;
		protected var zeroAngleChanged:Boolean = true;
		
		protected var maximumChanged:Boolean = true;

		public var snapToCursor:Boolean = false;
		public var allowLooping:Boolean = false;
		protected var startCursorAngle:Number = NaN;
		protected var gripAngleOffset:Number = NaN;
		protected var previousCursorAngle:Number = NaN;
		protected var cursorAngleDelta:Number = 0;
		protected var startAngleToMinDifference:Number = 0;
		protected var startAngleToMaxDifference:Number = 0;
		protected var dial:Image;

		public function TermsDial()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
			dial = new Image(atlas.getTexture('TermOfLoanDial3'));
			addChild(dial);
			
			this.pivotX = dial.pivotX = dial.width / 2.0;
			this.pivotY = dial.pivotY = dial.height / 2.0;
			
			this.value = Values.terms || 1;

			dial.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this);

			for each (var touch:Touch in touches)
			{
				cursorPosStage = touch.getLocation(stage);
				// have to add the difference to the center... not sure why yet
				cursorPosStage.x += 78;
				cursorPosStage.y += 78;

				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						beginInteractHandler();
						break;
					case TouchPhase.MOVED:
						motionInteractHandler();
						break;
					case TouchPhase.ENDED:

						break;
				}
			}
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(val:Number):void
		{
			if (_value != val)
			{
				_value = val;
				valueChanged = true;
			}
		}

		public function get zeroAngle():Number
		{
			return _zeroAngle;
		}

		public function set zeroAngle(value:Number):void
		{
			if (_zeroAngle != value)
			{
				_zeroAngle = value;
				zeroAngleChanged = true;
			}
		}

		public function get maxRotation():Number
		{
			return _maxRotation;
		}

		public function set maxRotation(value:Number):void
		{
			if (_maxRotation != value)
			{
				_maxRotation = value;
				maxRotationChanged = true;
			}
		}

		public function get minimum():Number
		{
			return _minimum;
		}

		public function set minimum(value:Number):void
		{
			if (_minimum != value)
			{
				_minimum = value;
				minimumChanged = true;
			}
		}

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			if (_maximum != value)
			{
				_maximum = value;
				maximumChanged = true;
			}
		}

		protected function beginInteractHandler():void
		{

			startCursorAngle = getCursorAngle();

			if (snapToCursor)
			{
				if (startCursorAngle > maxRotation)
				{
					var currentThumbAngle:Number = getAngleFromValue(value);
					var oppositeCurrentAngle:Number = currentThumbAngle + 180;

					if (startCursorAngle > oppositeCurrentAngle)
					{
						startCursorAngle = 0;
					}
					else
					{
						startCursorAngle = maxRotation;
					}
				}

				setValueForAngle(startCursorAngle);

				gripAngleOffset = 0;
			}
			else
			{
				gripAngleOffset = startCursorAngle - getAngleFromValue(value);
			}

			previousCursorAngle = startCursorAngle;
			cursorAngleDelta = 0;
			startAngleToMinDifference = -(startCursorAngle - gripAngleOffset);
			startAngleToMaxDifference = maxRotation - (startCursorAngle - gripAngleOffset);
		}

		protected function motionInteractHandler():void
		{
			var mouseAngle:Number = getCursorAngle();

			var newThumbAngle:Number = mouseAngle - gripAngleOffset;

			newThumbAngle = sanitize360(newThumbAngle);

			var oppositePreviousAngle:Number = (previousCursorAngle + 180) % 360;
			var movingClockwise:Boolean = containsAngle(mouseAngle, previousCursorAngle, oppositePreviousAngle);

			if (movingClockwise)
			{
				cursorAngleDelta += subtractAngle(mouseAngle, previousCursorAngle);
			}
			else
			{
				cursorAngleDelta -= subtractAngle(previousCursorAngle, mouseAngle);
			}

			if (allowLooping && newThumbAngle > maxRotation)
			{
				var snapDividingAngle:Number = maxRotation + (360 - maxRotation) / 2;

				if (newThumbAngle <= snapDividingAngle)
				{
					newThumbAngle = maxRotation;
				}
				else
				{
					newThumbAngle = 0;
				}
			}

			if (!allowLooping)
			{
				if (cursorAngleDelta < startAngleToMinDifference)
				{
					newThumbAngle = 0;
				}
				else if (cursorAngleDelta > startAngleToMaxDifference)
				{
					newThumbAngle = maxRotation;
				}
			}

			setValueForAngle(newThumbAngle);
			previousCursorAngle = mouseAngle;
		}

		/**
		 * Ensures an angle is between 0 and 360.
		 *
		 * @param value The angle to sanitize.
		 * @return The angle between 0 and 360.
		 */
		protected function sanitize360(value:Number):Number
		{
			value %= 360;

			if (value < 0)
			{
				value = 360 + value;
			}

			return value
		}

		protected function setValueForAngle(angle:Number):void
		{
			var anglePercentage:Number = angle / maxRotation;
			var valueForAngle:Number = minimum + anglePercentage * (maximum - minimum);

			valueForAngle = Math.max(minimum, valueForAngle);
			valueForAngle = Math.min(maximum, valueForAngle);

			value = valueForAngle;
			valueChangedByInteraction = true;
		}

		protected function containsAngle(angle:Number, leftBoundAngle:Number, rightBoundAngle:Number):Boolean
		{
			if (rightBoundAngle <= leftBoundAngle)
			{
				if (angle <= rightBoundAngle)
				{
					angle += 360;
				}
				rightBoundAngle += 360;
			}

			return (angle >= leftBoundAngle && angle <= rightBoundAngle);
		}

		protected function subtractAngle(rightAngle:Number, leftAngle:Number):Number
		{
			if (rightAngle >= leftAngle) 
			{
				return rightAngle - leftAngle;
			}
			else
			{
				return (360 - leftAngle) + rightAngle;
			}
		}

		protected function getCursorAngle():Number
		{
			var knobCenter:Point = new Point(width / 2, height / 2);
			knobCenter = localToGlobal(knobCenter);
			return toCustomVector(toDegrees(Math.atan2(cursorPosStage.y - this.y, cursorPosStage.x - this.x)));
		}

		protected function updateKnob():void
		{
			dial.rotation = toRadians(toStandardVector(getAngleFromValue(value)))
		}

		protected function getAngleFromValue(value:Number):Number
		{
			if (value < minimum || value > maximum)
			{
				throw new Error('Invalid value found when attempting to retrieve angle.');
			}

			var valuePercentage:Number = (value - minimum) / (maximum - minimum);
			var angleForValue:Number = valuePercentage * maxRotation;
			return angleForValue;
		}

		public function toCustomVector(angle:Number):Number
		{
			if (angle < -180 || angle > 180)
			{
				throw new Error('Angle should be between -180 and 180');
			}

			if (angle < 0)
			{
				angle = 360 + angle;
			}

			var comparativeZeroAngle:Number = zeroAngle;

			if (zeroAngle < 0)
			{
				comparativeZeroAngle = 360 + zeroAngle;
			}

			if (angle < comparativeZeroAngle)
			{
				angle += 360;
			}

			angle -= comparativeZeroAngle;

			return angle;
		}

		public function toStandardVector(angle:Number):Number
		{
			if (angle < 0 || angle > 360)
			{
				throw new Error('Angle should be between 0 and 360');
			}

			angle %= 360;

			if (angle < 0)
			{
				angle = 360 - Math.abs(angle);
			}

			angle += zeroAngle;

			angle %= 360;

			if (angle > 180)
			{
				angle = -180 + (angle - 180);
			}

			return angle;
		}

		protected function toRadians(value:Number):Number
		{
			return value * (Math.PI / 180);
		}

		protected function toDegrees(value:Number):Number
		{
			return value * (180 / Math.PI);
		}

		public function update():void
		{
			updateKnob();
		}

		public function destroy():void
		{
			dial.removeEventListener(TouchEvent.TOUCH, onTouch);
			
		}
	}
}
