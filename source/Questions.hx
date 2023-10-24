package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.ui.FlxBar;
import flixel.FlxCamera;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import lime.system.Clipboard;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.crypto.Aes;
import haxe.crypto.Base64;
import haxe.crypto.mode.Mode;
import haxe.crypto.padding.*;
import file.save.FileSave;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if android
import openfl.events.KeyboardEvent;
import flash.events.TextEvent;
import openfl.display.Stage;
import flash.ui.Keyboard;
#end
class Questions extends FlxState
{
	private var camGame:FlxCamera;
	
	public static var CorrectAnswers:Int = 0;
	var AmountOfQuestions:Int = 16;
	public static var curUser:String = '';
	
	var key = Bytes.ofHex("3DV5GB7N1WS8M7HDFDD35L8K0G3V7M84B2SC4F5G6HN3B8M2V25V6B89M22V6Z2D");
	var iv:Bytes = Bytes.ofHex("5B9M2C6B4M7B2V8M3XZ96B4C7N2B9M0N");
	
	public static var CurQuestion:Int = 0;
	public static var EndOfTest:Bool = false;
	public static var TestWasStarted:Bool = false;
	public static var ending:Bool = false;
	var lock:Bool = false;
	
	var TypeOfQuestion:String = '';
	var AllAnswers:Array<String> = [''];
	var SelectedAnswers:Array<Int> = [];
	var CorrectAnswersAllString:Array<String> = [''];
	var CorrectAnswersAllInt:Array<Int> = [];
	var QuestionText:String = '';
	var AnswerText:String = '';
	var BackSpaceTimer:FlxTimer;
	var tintTimer:FlxTimer;
	
	var Questttiooonn:FlxText;
	var TextInput:FlxText;
	var EnterText:FlxText;
	var SaveResults:FlxText;
	var ResetResults:FlxText;
	var LoadResults:FlxText;
	var StartTest:FlxText;
	var tint:FlxText;
	
	var AnswerOne:FlxText;
	var AnswerTwo:FlxText;
	var AnswerThree:FlxText;
	var AnswerFour:FlxText;
	var AnswerFive:FlxText;
	var AnswerSix:FlxText;
	var AnswerSeven:FlxText;
	var AnswerEight:FlxText;
	
	var CompletionBarPercent:Float;
	var CompletionBar:FlxBar;
	var CompletionText:FlxText;

	override function create() {
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];
		super.create();

		CompletionBarPercent = (CurQuestion / AmountOfQuestions);
		CompletionBar = new FlxBar(0, 710, LEFT_TO_RIGHT, 1280, 720, this, 'CompletionBarPercent', 0, 1);
		CompletionBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		add(CompletionBar);

		CompletionText = new FlxText(0, 670, FlxG.width, "");
		CompletionText.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 25, 0xFFFFFFFF, LEFT);
		add(CompletionText);

		CompletionBar.visible = false;
		CompletionText.visible = false;

		if (!ending) {
			if (TestWasStarted) {
				if (!EndOfTest) {
					switch (CurQuestion) {
						case 0: QuestionCreate('text', 'Как называется процесс оценки системы?', [''], ['ВЕРИФИКАЦИЯ']);
						case 1: QuestionCreate('select-one', 'Валидация - это:', ['1. Определение соответствия разрабатываемого ПО ожиданиям и потребностям пользователя.', '2. Совокупность характеристик ПО, относящихся к его способности удовлетворять установленные и предполагаемые потребности.', '3. Метод тестирования, направленный на установление степени удобства использования.'], [''], [1]);
						case 2: QuestionCreate('select-one', 'Какой из данных вариантов не является целью тестирования?', ['1. Повысить вероятность того, что приложение, предназначенное для тестирования, будет работать правильно при любых обстоятельствах.', '2. Повысить вероятность того, что приложение, предназначенное для тестирования, будет соответствовать всем описанным требованиям.', '3. Разработка стратегии тестирования и планирование процедур контроля качества', '4. Предоставление актуальной информации о состоянии продукта на данный момент.'], [''], [3]);
						case 3: QuestionCreate('text', 'Как называется документ, описывающий весь объем работ по тестированию?', [''], ['ТЕСТ ПЛАН']);
						case 4: QuestionCreate('select-one', 'Совокупность характеристик программного обеспечения, относящихся к его способности удовлетворять установленные и предполагаемые потребности - это:', ['1. Матрица соответствия требований', '2. Анализ Граничных Значений', '3. Эквивалентное Разделение', '4. Качество программного обеспечения'], [''], [4]);
						case 5: QuestionCreate('select-some', 'Какие стадии проходит программный продукт?', ['Анализ требований к проекту', 'Проектирование', 'Трассируемость', 'Реализация', 'Тестирование продукта', 'Недвусмысленность', 'Внедрение и поддержка'], [''], [1,2,4,5,7]);
						case 6: QuestionCreate('select-one', 'SEVERITY - это:', ['1. Документ, описывающий ситуацию или последовательность действий приведшую к некорректной работе объекта тестирования', '2. Атрибут, указывающий на очередность выполнения задачи или устранения дефекта.', '3. Атрибут, характеризующий влияние дефекта на работоспособность приложения.'], [''], [3]);
						case 7: QuestionCreate('text', 'Документ, описывающий что должно быть протестировано - это:', [''], ['ЧЕК ЛИСТ']);
						case 8: QuestionCreate('select-one', 'Какой из данных пунктов не относится к принципам тестирования?', ['1. Defects clustering', '2. Pairwise Testing', '3. Pesticide paradox', '4. Testing shows presence of defects'], [''], [2]);
						case 9: QuestionCreate('text', 'Описание того, что должно быть реализовано - это:', [''], ['ТРЕБОВАНИЯ']);
						case 10: QuestionCreate('text', 'Ошибка программиста, когда в программе что-то идёт не так как планировалось - это:', [''], ['БАГ']);
						case 11: QuestionCreate('text', 'Документ, описывающий ситуацию или последовательность действий приведшую к некорректной работе - это:', [''], ['БАГ РЕПОРТ']);
						case 12: QuestionCreate('select-one', 'Тестирование когда проверяется взаимодействие между компонентами системы после проведения компонентного тестирования.', ['1. Операционное тестирование', '2. Интеграционное тестирование', '3. Модульное тестирование'], [''], [2]);
						case 13: QuestionCreate('select-some', 'Выберите только виды тестирования производительности:', ['Численное тестирование', 'Нагрузочное тестирование', 'Высшее тестирование', 'Стрессовое тестирование', 'Тестирование стабильности', 'Профессиональное тестирование', 'Объемное тестирование'], [''], [2,4,5,7]);
						case 14: QuestionCreate('text', 'Что направленно на проверку успешной инсталляции и настройки, а также обновления или удаления ПО.', [''], ['ТЕСТИРОВАНИЕ УСТАНОВКИ']);
						case 15: QuestionCreate('text', 'Тестирование, во время которого исполняются тестовые сценарии, выявившие ошибки во время последнего запуска.', [''], ['ПОВТОРНОЕ ТЕСТИРОВАНИЕ']);
					}
				} else { End(); }
			} else {
				var FIO:FlxText = new FlxText(0, 0, FlxG.width, 'Введите ФИО');
				FIO.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
				add(FIO);

				TextInput = new FlxText(0, 100, FlxG.width, AnswerText);
				TextInput.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
				add(TextInput);

				var box:FlxText = new FlxSprite(0,100).makeGraphic(FlxG.width, 100, 0xFF444444);
				add(box);

				LoadResults = new FlxText(0, 300, 170, 'Загрузить\nрезультаты');
				LoadResults.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 30, 0xFF767676, CENTER);
				LoadResults.screenCenter(X);
				LoadResults.x += 100;
				add(LoadResults);

				StartTest = new FlxText(0, 300, 120, 'Начать\nтест');
				StartTest.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 30, 0xFF767676, CENTER);
				StartTest.screenCenter(X);
				StartTest.x -= 100;
				add(StartTest);

				tint = new FlxText(0, 400, FlxG.width, '');
				tint.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 20, 0xFFFFFFFF, CENTER);
				tint.screenCenter(X);
				tint.alpha = 0;
				add(tint);

				var t3sty:FlxSprite = new FlxSprite(0,0).loadGraphic('assets/t3sty.png');
				t3sty.scale.x = 0.2;
				t3sty.scale.y = 0.2;
				t3sty.x -= 220;
				t3sty.y += 290;
				t3sty.antialiasing = true;
				add(t3sty);

				var funnytext:FlxText = new FlxText(10, 660, FlxG.width, 'T3sty: v1.0\nCoded By: Merphi :P');
				funnytext.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 20, 0xFFFFFFFF, LEFT);
				add(funnytext);
			}
		} else {
			End();
		}
	}
	function End() {
		CompletionBar.visible = true;
		CompletionText.visible = true;
	
		var TestFinish:FlxText = new FlxText(0, 0, FlxG.width, 'Тест успешно завершён');
		TestFinish.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 50, 0xFFFFFFFF, CENTER);
		add(TestFinish);
		
		var User:FlxText = new FlxText(0, 100, FlxG.width, 'ФИО: ' + curUser);
		User.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
		add(User);
		
		var WrongAmount:FlxText = new FlxText(0, 160, FlxG.width, 'Всего вопросов: ' + AmountOfQuestions);
		WrongAmount.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
		add(WrongAmount);
		
		var CorrectAmount:FlxText = new FlxText(0, 220, FlxG.width, 'Кол-во верных ответов: ' + CorrectAnswers + ' [' + Std.int((CorrectAnswers / AmountOfQuestions) * 100) + '%]');
		CorrectAmount.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
		add(CorrectAmount);

		var WrongAmount:FlxText = new FlxText(0, 280, FlxG.width, 'Кол-во неверных ответов: ' + (AmountOfQuestions - CorrectAnswers) + ' [' + (100 - Std.int((CorrectAnswers / AmountOfQuestions) * 100)) + '%]');
		WrongAmount.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
		add(WrongAmount);
		
		var ratinglol:Int = 0;
		ratinglol = Std.int((CorrectAnswers / AmountOfQuestions) * 100);
		var RateFR:Int = 0;
		if (ratinglol >= 0 && ratinglol <= 20) RateFR = 1;
		if (ratinglol > 20 && ratinglol <= 35) RateFR = 2;
		if (ratinglol > 35 && ratinglol <= 60) RateFR = 3;
		if (ratinglol > 60 && ratinglol <= 85) RateFR = 4;
		if (ratinglol > 85 && ratinglol <= 100) RateFR = 5;
		var Rate:FlxText = new FlxText(0, 340, FlxG.width, 'Оценка: ' + RateFR);
		Rate.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
		add(Rate);
		
		SaveResults = new FlxText(FlxG.width - 380, 620, 170, 'Сохранить\nрезультаты');
		SaveResults.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 30, 0xFF767676, CENTER);
		add(SaveResults);
		
		ResetResults = new FlxText(FlxG.width - 180, 620, 140, 'На главную');
		ResetResults.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 30, 0xFF767676, CENTER);
		add(ResetResults);
	}
	override function update(elapsed:Float)
	{
		CompletionBarPercent = (CurQuestion / AmountOfQuestions); 
		CompletionText.text = CurQuestion + '/' + AmountOfQuestions + '[' + Std.int(CompletionBarPercent*100) + '%' + ']';
		#if android
		if (FlxG.mouse.overlaps(TextInput) && FlxG.mouse.justPressed) {
			FlxG.stage.window.textInputEnabled = true;
			lock = !lock;
		}
		#end
		if (!lock) {
			if (!EndOfTest) {
				if (TestWasStarted) {
					switch (TypeOfQuestion) {
						case 'text':
							InputText();
							if (FlxG.keys.justPressed.BACKSPACE) {
								BackSpaceTimer = new FlxTimer().start(0, function(tmr:FlxTimer)
								{
									AnswerText = AnswerText.substring(0, AnswerText.length - 1);
									if (FlxG.keys.pressed.BACKSPACE && !FlxG.keys.justReleased.BACKSPACE) BackSpaceTimer.reset(0.2);
								});
							} else {
								if (BackSpaceTimer != null && FlxG.keys.justReleased.BACKSPACE) BackSpaceTimer.destroy();
							}
							TextInput.text = AnswerText;
						case 'select-one':
							if (!FlxG.mouse.overlaps(EnterText)) SelectionOfAnswers('one');
						case 'select-some':
							if (!FlxG.mouse.overlaps(EnterText)) SelectionOfAnswers('some');
					}
					if ((FlxG.mouse.overlaps(EnterText) && FlxG.mouse.justPressed) || FlxG.keys.justPressed.ENTER)
						EnterQuestion();
					if (FlxG.mouse.overlaps(EnterText))
						EnterText.color = 0xFFFFFFFF;
					else
						EnterText.color = 0xFF767676;
				} else {
					InputText();
					if (FlxG.keys.justPressed.BACKSPACE) {
						BackSpaceTimer = new FlxTimer().start(0, function(tmr:FlxTimer)
						{
							AnswerText = AnswerText.substring(0, AnswerText.length - 1);
							if (FlxG.keys.pressed.BACKSPACE && !FlxG.keys.justReleased.BACKSPACE) BackSpaceTimer.reset(0.2);
						});
					} else {
						if (BackSpaceTimer != null && FlxG.keys.justReleased.BACKSPACE) BackSpaceTimer.destroy();
					}
					TextInput.text = AnswerText;
					curUser = AnswerText;
				
					if (FlxG.mouse.overlaps(LoadResults) && FlxG.mouse.justPressed) {
						if (FileSystem.exists('results.save')) {
							var aes : Aes = new Aes();
							var text = Bytes.ofHex(File.getContent('results.save'));
							aes.init(key,iv);
							var dataDecrypt:String = Std.string(aes.decrypt(Mode.CTR,text,Padding.NoPadding));
							var Split:Array<String> = dataDecrypt.split("|");
							curUser = Split[1];
							CorrectAnswers = Std.parseInt(Split[2]);
							CurQuestion = Std.parseInt(Split[3]);
							AmountOfQuestions = Std.parseInt(Split[3]);
							TestWasStarted = true;
							EndOfTest = true;
							ending = true;
							FlxG.switchState(new Questions());
						} else {
							if (tintTimer != null) tintTimer.destroy();
							tint.alpha = 0;
							tint.text = 'Отсутствует файл <results.save> в корневой папке программы';
							FlxTween.tween(tint, {alpha: 1}, 0.15, {ease: FlxEase.quadInOut});
							tintTimer = new FlxTimer().start(3, function(ff:FlxTimer) {
								FlxTween.tween(tint, {alpha: 0}, 0.15, {ease: FlxEase.quadInOut});
							});
						}
					}
					if (FlxG.mouse.overlaps(LoadResults))
						LoadResults.color = 0xFFFFFFFF;
					else
						LoadResults.color = 0xFF767676;
					
					if ((FlxG.mouse.overlaps(StartTest) && FlxG.mouse.justPressed) || FlxG.keys.justPressed.ENTER) {
						var splt:Array<String> = AnswerText.split(" ");
						if (splt[0].length >= 4 && splt[1].length >= 2) {
							TestWasStarted = true;
							ending = false;
							FlxG.switchState(new Questions());
						} else {
							if (tintTimer != null) tintTimer.destroy();
							tint.alpha = 0;
							tint.text = 'ФИО недостаточно заполнено';
							FlxTween.tween(tint, {alpha: 1}, 0.15, {ease: FlxEase.quadInOut});
							tintTimer = new FlxTimer().start(2, function(ff:FlxTimer) {
								FlxTween.tween(tint, {alpha: 0}, 0.15, {ease: FlxEase.quadInOut});
							});
						}
					}
					if (FlxG.mouse.overlaps(StartTest))
						StartTest.color = 0xFFFFFFFF;
					else
						StartTest.color = 0xFF767676;
				}
			} else {
				if (FlxG.mouse.overlaps(SaveResults) && FlxG.mouse.justPressed) {
					var ResultsYay:String = '|' + curUser + '|' + AmountOfQuestions + '|' + CorrectAnswers + '|';
					var aes : Aes = new Aes();
					var text = Bytes.ofString(ResultsYay);
					aes.init(key,iv);
					var dataEncrypt = aes.encrypt(Mode.CTR,text,Padding.NoPadding);
					FileSave.saveString(Std.string(dataEncrypt.toHex()), "results.save", "");
				}
				if (FlxG.mouse.overlaps(SaveResults))
					SaveResults.color = 0xFFFFFFFF;
				else
					SaveResults.color = 0xFF767676;
					
				if ((FlxG.mouse.overlaps(ResetResults) && FlxG.mouse.justPressed) || FlxG.keys.justPressed.ENTER) {
					CurQuestion = 0;
					CorrectAnswers = 0;
					curUser = '';
					TestWasStarted = false;
					EndOfTest = false;
					ending = false;
					FlxG.switchState(new Questions());
				}
				if (FlxG.mouse.overlaps(ResetResults))
					ResetResults.color = 0xFFFFFFFF;
				else
					ResetResults.color = 0xFF767676;
			}
		}
		super.update(elapsed);
	}
	function EnterQuestion() {
		if (AmountOfQuestions != CurQuestion) {
			switch (TypeOfQuestion) {
				case 'text':
					if (CorrectAnswersAllString[0] == AnswerText)
						CorrectAnswers += 1;
					CurQuestion += 1;
					if (AmountOfQuestions == CurQuestion) EndOfTest = true;
					FlxG.switchState(new Questions());
				case 'select-one':
					if (SelectedAnswers[0] == CorrectAnswersAllInt[0])
						CorrectAnswers += 1;
					CurQuestion += 1;
					if (AmountOfQuestions == CurQuestion) EndOfTest = true;
					FlxG.switchState(new Questions());
				case 'select-some':
					switch (CorrectAnswersAllInt.length) {
						case 1: if (SelectedAnswers.contains(CorrectAnswersAllInt[0])) CorrectAnswers += 1;
						case 2: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1])) CorrectAnswers += 1;
						case 3: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1]) && SelectedAnswers.contains(CorrectAnswersAllInt[2])) CorrectAnswers += 1;
						case 4: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1]) && SelectedAnswers.contains(CorrectAnswersAllInt[2]) && SelectedAnswers.contains(CorrectAnswersAllInt[3])) CorrectAnswers += 1;
						case 5: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1]) && SelectedAnswers.contains(CorrectAnswersAllInt[2]) && SelectedAnswers.contains(CorrectAnswersAllInt[3]) && SelectedAnswers.contains(CorrectAnswersAllInt[4])) CorrectAnswers += 1;
						case 6: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1]) && SelectedAnswers.contains(CorrectAnswersAllInt[2]) && SelectedAnswers.contains(CorrectAnswersAllInt[3]) && SelectedAnswers.contains(CorrectAnswersAllInt[4]) && SelectedAnswers.contains(CorrectAnswersAllInt[5])) CorrectAnswers += 1;
						case 7: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1]) && SelectedAnswers.contains(CorrectAnswersAllInt[2]) && SelectedAnswers.contains(CorrectAnswersAllInt[3]) && SelectedAnswers.contains(CorrectAnswersAllInt[4]) && SelectedAnswers.contains(CorrectAnswersAllInt[5]) && SelectedAnswers.contains(CorrectAnswersAllInt[6])) CorrectAnswers += 1;
						case 8: if (SelectedAnswers.contains(CorrectAnswersAllInt[0]) && SelectedAnswers.contains(CorrectAnswersAllInt[1]) && SelectedAnswers.contains(CorrectAnswersAllInt[2]) && SelectedAnswers.contains(CorrectAnswersAllInt[3]) && SelectedAnswers.contains(CorrectAnswersAllInt[4]) && SelectedAnswers.contains(CorrectAnswersAllInt[5]) && SelectedAnswers.contains(CorrectAnswersAllInt[6]) && SelectedAnswers.contains(CorrectAnswersAllInt[7])) CorrectAnswers += 1;
					}
					CurQuestion += 1;
					if (AmountOfQuestions == CurQuestion) EndOfTest = true;
					FlxG.switchState(new Questions());
			}
		} else {
			EndOfTest = true;
			FlxG.switchState(new Questions());
		}
	}
	function SelectionOfAnswers(sel:String) {
		switch (sel) {
			case 'one':
				if (AllAnswers.length > 0) {
					if (AnswerOne.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerOne))
							AnswerOne.color = 0xFFFFFFFF;
						else
							AnswerOne.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerOne) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFF30B6FF;
							if (AllAnswers.length > 1) AnswerTwo.color = 0xFF767676;
							if (AllAnswers.length > 2) AnswerThree.color = 0xFF767676;
							if (AllAnswers.length > 3) AnswerFour.color = 0xFF767676;
							SelectedAnswers = [1];
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerOne) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFFFFFFFF;
							SelectedAnswers = [];
						}
					}
				}
				if (AllAnswers.length > 1) {
					if (AnswerTwo.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerTwo))
							AnswerTwo.color = 0xFFFFFFFF;
						else
							AnswerTwo.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerTwo) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFF767676;
							AnswerTwo.color = 0xFF30B6FF;
							if (AllAnswers.length > 2) AnswerThree.color = 0xFF767676;
							if (AllAnswers.length > 3) AnswerFour.color = 0xFF767676;
							SelectedAnswers = [2];
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerTwo) && FlxG.mouse.justPressed) {
							AnswerTwo.color = 0xFFFFFFFF;
							SelectedAnswers = [];
						}
					}
				}
				if (AllAnswers.length > 2) {
					if (AnswerThree.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerThree))
							AnswerThree.color = 0xFFFFFFFF;
						else
							AnswerThree.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerThree) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFF767676;
							AnswerTwo.color = 0xFF767676;
							AnswerThree.color = 0xFF30B6FF;
							if (AllAnswers.length > 3) AnswerFour.color = 0xFF767676;
							SelectedAnswers = [3];
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerThree) && FlxG.mouse.justPressed) {
							AnswerThree.color = 0xFFFFFFFF;
							SelectedAnswers = [];
						}
					}
				}
				if (AllAnswers.length > 3) {
					if (AnswerFour.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerFour))
							AnswerFour.color = 0xFFFFFFFF;
						else
							AnswerFour.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerFour) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFF767676;
							AnswerTwo.color = 0xFF767676;
							AnswerThree.color = 0xFF767676;
							AnswerFour.color = 0xFF30B6FF;
							SelectedAnswers = [4];
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerFour) && FlxG.mouse.justPressed) {
							AnswerFour.color = 0xFFFFFFFF;
							SelectedAnswers = [];
						}
					}
				}
			case 'some':
				if (AllAnswers.length > 0) {
					if (AnswerOne.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerOne))
							AnswerOne.color = 0xFFFFFFFF;
						else
							AnswerOne.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerOne) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(1)) SelectedAnswers.push(1);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerOne) && FlxG.mouse.justPressed) {
							AnswerOne.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(1)) SelectedAnswers.remove(1);
						}
					}
				}
				if (AllAnswers.length > 1) {
					if (AnswerTwo.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerTwo))
							AnswerTwo.color = 0xFFFFFFFF;
						else
							AnswerTwo.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerTwo) && FlxG.mouse.justPressed) {
							AnswerTwo.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(2)) SelectedAnswers.push(2);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerTwo) && FlxG.mouse.justPressed) {
							AnswerTwo.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(2)) SelectedAnswers.remove(2);
						}
					}
				}
				if (AllAnswers.length > 2) {
					if (AnswerThree.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerThree))
							AnswerThree.color = 0xFFFFFFFF;
						else
							AnswerThree.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerThree) && FlxG.mouse.justPressed) {
							AnswerThree.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(3)) SelectedAnswers.push(3);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerThree) && FlxG.mouse.justPressed) {
							AnswerThree.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(3)) SelectedAnswers.remove(3);
						}
					}
				}
				if (AllAnswers.length > 3) {
					if (AnswerFour.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerFour))
							AnswerFour.color = 0xFFFFFFFF;
						else
							AnswerFour.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerFour) && FlxG.mouse.justPressed) {
							AnswerFour.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(4)) SelectedAnswers.push(4);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerFour) && FlxG.mouse.justPressed) {
							AnswerFour.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(4)) SelectedAnswers.remove(4);
						}
					}
				}
				if (AllAnswers.length > 4) {
					if (AnswerFive.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerFive))
							AnswerFive.color = 0xFFFFFFFF;
						else
							AnswerFive.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerFive) && FlxG.mouse.justPressed) {
							AnswerFive.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(5)) SelectedAnswers.push(5);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerFive) && FlxG.mouse.justPressed) {
							AnswerFive.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(5)) SelectedAnswers.remove(5);
						}
					}
				}
				if (AllAnswers.length > 5) {
					if (AnswerSix.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerSix))
							AnswerSix.color = 0xFFFFFFFF;
						else
							AnswerSix.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerSix) && FlxG.mouse.justPressed) {
							AnswerSix.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(6)) SelectedAnswers.push(6);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerSix) && FlxG.mouse.justPressed) {
							AnswerSix.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(6)) SelectedAnswers.remove(6);
						}
					}
				}
				if (AllAnswers.length > 6) {
					if (AnswerSeven.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerSeven))
							AnswerSeven.color = 0xFFFFFFFF;
						else
							AnswerSeven.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerSeven) && FlxG.mouse.justPressed) {
							AnswerSeven.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(7)) SelectedAnswers.push(7);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerSeven) && FlxG.mouse.justPressed) {
							AnswerSeven.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(7)) SelectedAnswers.remove(7);
						}
					}
				}
				if (AllAnswers.length > 7) {
					if (AnswerEight.color != 0xFF30B6FF) {
						if (FlxG.mouse.overlaps(AnswerEight))
							AnswerEight.color = 0xFFFFFFFF;
						else
							AnswerEight.color = 0xFF767676;
						if (FlxG.mouse.overlaps(AnswerEight) && FlxG.mouse.justPressed) {
							AnswerEight.color = 0xFF30B6FF;
							if (!SelectedAnswers.contains(8)) SelectedAnswers.push(8);
						}
					} else {
						if (FlxG.mouse.overlaps(AnswerEight) && FlxG.mouse.justPressed) {
							AnswerEight.color = 0xFFFFFFFF;
							if (SelectedAnswers.contains(8)) SelectedAnswers.remove(8);
						}
					}
				}
		}
	}
	function InputText() {
		if (AnswerText.length <= 40) {
			#if sys
			if (FlxG.keys.justPressed.Q) AnswerText = AnswerText + 'Й';
			if (FlxG.keys.justPressed.W) AnswerText = AnswerText + 'Ц';
			if (FlxG.keys.justPressed.E) AnswerText = AnswerText + 'У';
			if (FlxG.keys.justPressed.R) AnswerText = AnswerText + 'К';
			if (FlxG.keys.justPressed.T) AnswerText = AnswerText + 'Е';
			if (FlxG.keys.justPressed.Y) AnswerText = AnswerText + 'Н';
			if (FlxG.keys.justPressed.U) AnswerText = AnswerText + 'Г';
			if (FlxG.keys.justPressed.I) AnswerText = AnswerText + 'Ш';
			if (FlxG.keys.justPressed.O) AnswerText = AnswerText + 'Щ';
			if (FlxG.keys.justPressed.P) AnswerText = AnswerText + 'З';
			if (FlxG.keys.justPressed.LBRACKET && !FlxG.keys.pressed.SHIFT) AnswerText = AnswerText + 'Х';
			if (FlxG.keys.justPressed.RBRACKET && !FlxG.keys.pressed.SHIFT) AnswerText = AnswerText + 'Ъ';
			
			if (FlxG.keys.justPressed.A) AnswerText = AnswerText + 'Ф';
			if (FlxG.keys.justPressed.S) AnswerText = AnswerText + 'Ы';
			if (FlxG.keys.justPressed.D) AnswerText = AnswerText + 'В';
			if (FlxG.keys.justPressed.F) AnswerText = AnswerText + 'А';
			if (FlxG.keys.justPressed.G) AnswerText = AnswerText + 'П';
			if (FlxG.keys.justPressed.H) AnswerText = AnswerText + 'Р';
			if (FlxG.keys.justPressed.J) AnswerText = AnswerText + 'О';
			if (FlxG.keys.justPressed.K) AnswerText = AnswerText + 'Л';
			if (FlxG.keys.justPressed.L) AnswerText = AnswerText + 'Д';
			if (FlxG.keys.justPressed.SEMICOLON && !FlxG.keys.pressed.SHIFT) AnswerText = AnswerText + 'Ж';
			if (FlxG.keys.justPressed.QUOTE && !FlxG.keys.pressed.SHIFT) AnswerText = AnswerText + 'Э';
			
			if (FlxG.keys.justPressed.Z) AnswerText = AnswerText + 'Я';
			if (FlxG.keys.justPressed.X) AnswerText = AnswerText + 'Ч';
			if (FlxG.keys.justPressed.C) AnswerText = AnswerText + 'С';
			if (FlxG.keys.justPressed.V) AnswerText = AnswerText + 'М';
			if (FlxG.keys.justPressed.B) AnswerText = AnswerText + 'И';
			if (FlxG.keys.justPressed.N) AnswerText = AnswerText + 'Т';
			if (FlxG.keys.justPressed.M) AnswerText = AnswerText + 'Ь';
			if (FlxG.keys.justPressed.COMMA && !FlxG.keys.pressed.SHIFT) AnswerText = AnswerText + 'Б';
			if (FlxG.keys.justPressed.PERIOD && !FlxG.keys.pressed.SHIFT) AnswerText = AnswerText + 'Ю';
			
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.LBRACKET) AnswerText = AnswerText + '[';
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.RBRACKET) AnswerText = AnswerText + ']';
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.SEMICOLON) AnswerText = AnswerText + ';';
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.QUOTE) AnswerText = AnswerText + '"';
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.COMMA) AnswerText = AnswerText + ',';
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.PERIOD) AnswerText = AnswerText + '.';
			if (FlxG.keys.justPressed.SPACE) AnswerText = AnswerText + ' ';
			//if (FlxG.keys.justPressed.ENTER) AnswerText = AnswerText + '\n';
			#else
			AnswerText.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			#end
		}
	}
	function QuestionCreate(Type:String, Question:String, AllAnsw:Array<String>, CorrectAnswString:Array<String>, ?CorrectAnswInt:Array<Int> = null)
	{
		TypeOfQuestion = Type;
		AllAnswers = AllAnsw;
		CorrectAnswersAllString = CorrectAnswString;
		CorrectAnswersAllInt = CorrectAnswInt;
		QuestionText = Question;
		CompletionBar.visible = true;
		CompletionText.visible = true;
		switch (TypeOfQuestion) {
			case 'text':
				Questttiooonn = new FlxText(0, 0, FlxG.width, Question);
				Questttiooonn.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
				add(Questttiooonn);
				
				TextInput = new FlxText(0, 100, FlxG.width, AnswerText);
				TextInput.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
				add(TextInput);

				if (CurQuestion != AmountOfQuestions-1)
					EnterText = new FlxText(FlxG.width - 150, 640, 140, 'Далее');
				else
					EnterText = new FlxText(FlxG.width - 150, 640, 140, 'Конец');
				EnterText.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFF767676, CENTER);
				add(EnterText);
			case 'select-one':
				Questttiooonn = new FlxText(0, 0, FlxG.width, Question);
				Questttiooonn.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
				add(Questttiooonn);
				
				if (CurQuestion != AmountOfQuestions-1)
					EnterText = new FlxText(FlxG.width - 150, 640, 140, 'Далее');
				else
					EnterText = new FlxText(FlxG.width - 150, 640, 140, 'Конец');
				EnterText.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFF767676, CENTER);
				add(EnterText);
				
				switch (AllAnswers.length) {
					case 1:
						AnswerOne = new FlxText(0, 360, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerOne);
					case 2:
						AnswerOne = new FlxText(0, 320, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 400, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerTwo);
					case 3:
						AnswerOne = new FlxText(0, 280, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 360, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 440, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerThree);
					case 4:
						AnswerOne = new FlxText(0, 240, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 320, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 400, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerThree);
						AnswerFour = new FlxText(0, 480, FlxG.width, AllAnsw[3]);
						AnswerFour.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 35, 0xFF767676, CENTER);
						add(AnswerFour);
				}
			case 'select-some':
				Questttiooonn = new FlxText(0, 0, FlxG.width, Question);
				Questttiooonn.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFFFFFFFF, CENTER);
				add(Questttiooonn);

				if (CurQuestion != AmountOfQuestions-1)
					EnterText = new FlxText(FlxG.width - 150, 640, 140, 'Далее');
				else
					EnterText = new FlxText(FlxG.width - 150, 640, 140, 'Конец');
				EnterText.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 40, 0xFF767676, CENTER);
				add(EnterText);
				
				switch (AllAnswers.length) {
					case 1:
						AnswerOne = new FlxText(0, 360, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
					case 2:
						AnswerOne = new FlxText(0, 320, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 400, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
					case 3:
						AnswerOne = new FlxText(0, 280, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 360, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 440, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerThree);
					case 4:
						AnswerOne = new FlxText(0, 240, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 320, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 400, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerThree);
						AnswerFour = new FlxText(0, 480, FlxG.width, AllAnsw[3]);
						AnswerFour.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFour);
					case 5:
						AnswerOne = new FlxText(0, 200, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 280, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 360, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerThree);
						AnswerFour = new FlxText(0, 440, FlxG.width, AllAnsw[3]);
						AnswerFour.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFour);
						AnswerFive = new FlxText(0, 520, FlxG.width, AllAnsw[4]);
						AnswerFive.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFive);
					case 6:
						AnswerOne = new FlxText(0, 160, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 240, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 320, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerThree);
						AnswerFour = new FlxText(0, 400, FlxG.width, AllAnsw[3]);
						AnswerFour.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFour);
						AnswerFive = new FlxText(0, 480, FlxG.width, AllAnsw[4]);
						AnswerFive.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFive);
						AnswerSix = new FlxText(0, 560, FlxG.width, AllAnsw[5]);
						AnswerSix.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerSix);
					case 7:
						AnswerOne = new FlxText(0, 120, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 200, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 280, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerThree);
						AnswerFour = new FlxText(0, 360, FlxG.width, AllAnsw[3]);
						AnswerFour.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFour);
						AnswerFive = new FlxText(0, 440, FlxG.width, AllAnsw[4]);
						AnswerFive.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFive);
						AnswerSix = new FlxText(0, 520, FlxG.width, AllAnsw[5]);
						AnswerSix.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerSix);
						AnswerSeven = new FlxText(0, 600, FlxG.width, AllAnsw[6]);
						AnswerSeven.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerSeven);
					case 8:
						AnswerOne = new FlxText(0, 80, FlxG.width, AllAnsw[0]);
						AnswerOne.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerOne);
						AnswerTwo = new FlxText(0, 160, FlxG.width, AllAnsw[1]);
						AnswerTwo.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerTwo);
						AnswerThree = new FlxText(0, 240, FlxG.width, AllAnsw[2]);
						AnswerThree.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerThree);
						AnswerFour = new FlxText(0, 320, FlxG.width, AllAnsw[3]);
						AnswerFour.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFour);
						AnswerFive = new FlxText(0, 400, FlxG.width, AllAnsw[4]);
						AnswerFive.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerFive);
						AnswerSix = new FlxText(0, 480, FlxG.width, AllAnsw[5]);
						AnswerSix.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerSix);
						AnswerSeven = new FlxText(0, 560, FlxG.width, AllAnsw[6]);
						AnswerSeven.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerSeven);
						AnswerEight = new FlxText(0, 640, FlxG.width, AllAnsw[7]);
						AnswerEight.setFormat(Paths.font("DejaVuSerifCondensed.ttf"), 60, 0xFF767676, CENTER);
						add(AnswerEight);
				}
		}
	}
}