package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	public class DragonUncharted extends Sprite
	{
		private var _txt1:TextField;
		private var _txt2:TextField;
		private var _out:TextField;
		
		private var _self:modelPlayer = new modelPlayer();
		private var _other:modelPlayer = new modelPlayer();
		private var _game:modelGame = new modelGame();
		private var _round:modelRound = new modelRound();
		
		private const HOST:String = "ariesyxyx.byethost11.com";
//		private const HOST:String = "localhost:8888";
		
		private var _timeId:int;
		
		
		private var d:String = "sdfsadfsdfsd"
		private function fntest():void
		{
			var i:Object = {a:"b", c:"d"};
			
			trace(i.e); //Outputs undefined
			
			if(i.e==undefined)
			{
				trace("true")	
			}
			else
			{
				trace("flase")
			}

		}
		
		public function DragonUncharted()
		{
			super();
			fntest();
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_txt1 = new TextField();
			_txt1.text = "12345678901234567890123456789001";
			_txt1.autoSize = TextFieldAutoSize.LEFT;
			_txt1.y = 10;
			
			_txt2 = new TextField();
			//_txt2.text = "10098765432109876543210987654321";
			_txt2.text = "A97445FAA85C24AC41D26A2511D26EBB";
			_txt2.autoSize = TextFieldAutoSize.LEFT;
			_txt2.y = 30;
		
		
			_out = new TextField();
			_out.autoSize = TextFieldAutoSize.LEFT;
			_out.border = true;
			_out.y = 50;
			
			this.addChild(_txt1);
			this.addChild(_txt2);
			this.addChild(_out);
			
			_txt1.addEventListener(MouseEvent.CLICK, Click_txt1, false, 0, true);
			_txt2.addEventListener(MouseEvent.CLICK, Click_txt2, false, 0, true)
		}
		
		private function log($log:String, $override:Boolean = false):void
		{
			trace($log);
			if($override)
				_out.text = $log + "\n";
			else
				_out.text += $log + "\n";
		}
		
		private function Click_txt1(e:MouseEvent):void
		{
			if(_txt1.text == "Leave game"){
				_txt1.text = "12345678901234567890123456789001";
				_txt2.text = "A97445FAA85C24AC41D26A2511D26EBB";
				log("Pls signin again",true);
				return;
			}else if(_txt1.text == "12345678901234567890123456789001"){
				Send_SignIn(_txt1.text);
			}else if(_txt1.text == "Enter game"){
				Send_EnterGame();
			}else if(_txt1.text == "Start Round"){
				Send_StartRound();
			}else if(_txt1.text == "End Round"){
				Send_EndRound();
			}else if(_txt1.text == "Over Round"){
				Send_OverRound();
			}else{
				return;
			}
			_txt1.text = "";
			_txt2.text = "";
		}
		
		private function Click_txt2(e:MouseEvent):void
		{
			if(_txt2.text == "Continue"){
				/// player game_id &seat_no reset
				Send_EnterGame();
			}else if(_txt2.text == "A97445FAA85C24AC41D26A2511D26EBB"){
				Send_SignIn(_txt2.text);
			}else{
				return;
			}
			_txt2.text = "";
			_txt1.text = "";
		}
		
		private function UI_UpdateGamePlayer():void
		{
			var len:int = _game.player_max;
			var print:String = "";
			var sn:String;
			var p:Object;
			for(var i:int = 0; i<len ; i++)
			{
				p = _game.players[i];
				sn = (_self.seat_no == i)?"<"+(i+1)+">":(i+1).toString();
				print += sn+"."+p.uuid+"\n HP:"+p.hp+" Attack:"+p.attack+" Defend:"+p.defend+"\n\n";
			}
			log(print,true);
		}
		
		private function UI_UpdatePlayer():void
		{
			var len:int = _game.player_max;
			var print:String = "";
			var sn:String;
			var hp:int, attack:int, defend:int;
			for(var i:int = 0; i<len ; i++)
			{
				sn = (_self.seat_no == i)?"<"+(i+1)+">":(i+1).toString();
				hp = _round.hp && _round.hp[i] ? _round.hp[i] : _game.players[i].hp;
				attack = _round.attack && _round.attack[i] != null? _round.attack[i] : _game.players[i].attack;
				defend = _round.defend && _round.defend[i] != null ? _round.defend[i] : _game.players[i].defend;
				print += sn+"."+_game.players[i].uuid+"\n HP:"+hp+" Attack:"+attack+" Defend:"+defend+"\n\n";
			}
			log(print,true);
		}
		
		private function UI_GameReady():void
		{	
			UI_UpdatePlayer();
			
			log("Game ready | Round "+_game.round_no +" / "+_game.round_max);
			
			_txt1.text = "Start Round";
		}
		
		private function UI_GameStart():void
		{
			UI_UpdatePlayer();
			log("\nRound "+_game.round_no +" Start !! Time : "+(_round.time--));
			
			if(_round.time < 0) {
				_txt1.text = "End Round";
			}else{
				setTimeout(UI_GameStart, 1000);
			}
		}
		
		private function UI_EndRound():void
		{
			UI_UpdatePlayer();
			log("Round "+_game.round_no +" end ");
			
			_txt1.text = "Over Round";
		}
		
		private function UI_OverRound():void
		{
			UI_UpdatePlayer();
			log("Round "+_game.round_no +" over ");
			
			_txt1.text = "Start Round";
		}
		
		private function UI_GameOver():void
		{
			UI_UpdatePlayer();
			log("Game Over Winner is "+_round.winner);
			
			_txt1.text = "Leave game";
			_txt2.text = "Continue";
		}
		
		private function Send_SignIn($uuid:String):void
		{
			var $json:String = '{"uuid":"'+$uuid+'"}';
			WebCommunicationHelper.instance.request("http://"+HOST+"/DragonUncharted/signIn.php",$json,URLRequestMethod.POST, Receive_SignIn);
		}
		
		private function Receive_SignIn(e:Event):void
		{
			trace("signInCompleted :"+e.target.data);
			_self.decodeJSON(e.target.data);
			
			///manual 
			if(_self.game_id == -1)
			{
				_txt1.text = "Enter game";
				_txt2.text = "";
				log("Sign in success!! Press enter game pls",true);
			}
			else
			{
				Send_EnterGame();
			}
//			enterGame();
		}
		
		private function Send_EnterGame():void
		{
			var $json:String = '{"uuid":"'+_self.uuid+'","game_id":'+_self.game_id+'}';
			WebCommunicationHelper.instance.request("http://"+HOST+"/DragonUncharted/enterGame.php",$json,URLRequestMethod.POST, Receive_EnterGame);
		}
		
		private function Receive_EnterGame(e:Event):void
		{
			trace("Receive_EnterGame :"+e.target.data); 
			
			var jsonObject:Object = JSON.parse(e.target.data);
			
			_game.convert(jsonObject.game);
			
			for each(var player_:Object in _game.players){
				if(player_.uuid == _self.uuid){
					_self.convert(player_);
					break;
				}
			}
			
			/// initial game info
			switch(_game.state)
			{
				case enumGameState.PARING:{
					/// show waiting...
					setTimeout(Send_EnterGame,1000);
					log("Enter Game Waiting...");
					break;
				}
				case enumGameState.PLAYING:{
					if(jsonObject.round)
					{
						_round.convert(jsonObject.round);
					}
					_other.convert(_game.players[(_self.seat_no ^ 1)]);
					Detect_RoundState();
					break;
				}
				case enumGameState.GAMEOVER:{
					/// show result
					break;
				}
			}
		}
		
		private function Send_StartRound():void
		{
			var $json:String = '{"uuid":"'+_self.uuid+'"}';
			WebCommunicationHelper.instance.request("http://"+HOST+"/DragonUncharted/startRound.php",$json,URLRequestMethod.POST, Receive_StartRound);
		}
		
		private function Receive_StartRound(e:Event):void
		{
			trace("\n Receive_StartRound :"+e.target.data);
//			_rounds[_game.round_no]
			var obj_:Object = JSON.parse(e.target.data);
			_game.round_no = obj_.round_no;
			_round.convert(obj_);
			
			Detect_RoundState();
		}
		
		private function Send_EndRound():void
		{
			var $json:String = '{"uuid":"'+_self.uuid+'","round_id":"'+_round.id+'","attack":'+int(Math.random() * _self.attack)+',"defend":'+int(Math.random() * _self.defend)+'}';
//			var $json:String = '{"uuid":"'+_self.uuid+'","round_id":"'+_round.id+'","attack":'+1+',"defend":'+1+'}';
			WebCommunicationHelper.instance.request("http://"+HOST+"/DragonUncharted/endRound.php",$json,URLRequestMethod.POST, Receive_EndRound);
		}
		
		private function Receive_EndRound(e:Event):void
		{
			trace("\n Receive_EndRound :"+e.target.data);
			_round.decodeJSON(e.target.data);
			Detect_RoundState();
		}
		
		private function Send_OverRound():void
		{
			var $json:String = '{"uuid":"'+_self.uuid+'","round_id":"'+_round.id+'"}';
			WebCommunicationHelper.instance.request("http://"+HOST+"/DragonUncharted/overRound.php",$json,URLRequestMethod.POST, Receive_OverRound);
		}
		
		private function Receive_OverRound(e:Event):void
		{
			trace("\n Receive_OverRound :"+e.target.data);
			
			_round.decodeJSON(e.target.data);
			Detect_RoundState();
		}
		
		private function Detect_RoundState():void
		{
			/// no round start
			if(_round.id == null && _round.state == enumRoundState.CREATED)
			{
				UI_GameReady();
			}
			else
			{
				/// 拿到這些狀態再對應UI要做什麼呈現
				switch(_round.state)
				{
					/// 等待中，再送出startRound()等待狀態改變
					case enumRoundState.ROUND_START_WAITING:
						log("Round start waiting...");
						setTimeout(Send_StartRound,1000);
						break;
					/// 趕快開始玩看看剩多少時間
					case enumRoundState.ROUND_START:
						UI_GameStart();
						break;
					/// 等待中，再送出endRound()等待狀態改變
					case enumRoundState.ROUND_END_WAITING:
						log("Round end waiting...");
						setTimeout(Send_EndRound,1000);
						break;
					/// 秀此Round結果
					case enumRoundState.ROUND_END:
					    UI_EndRound(); 	
						break;
					/// 等待中，再送出overRound()等待狀態改變
					case enumRoundState.ROUND_OVER_WAITING:
						log("Round over waiting...");
						setTimeout(Send_OverRound,1000);
						break;
					/// 秀轉到下一Round
					case enumRoundState.ROUND_OVER:
						if(_round.game_over){
							UI_GameOver();
							_self.game_id = -1;
							_self.seat_no = -1;
							_other = new modelPlayer();
							_game = new modelGame();
							_round = new modelRound();
							
						}else{
							UI_OverRound();
						}
						break;
					default:
						log("detectRoundState Round state "+_round.state+" error");
						break;
				}
			}
		}
	}
}