extends Node


var curStage
enum Bosses {Guilt, Hate, Pain, Torment, Dread, Revulsion, Hysteria, Fury}
var deadBosses = [false, false, false, false, false, false, false, false]
enum stageList {Aristocracy, Prison, Ashnora, Slums, Chapel, EmporersChamber, Square, Barracks, Lab1, Lab2, InnerChamber, Intro}
var heartsObtained = [false, false, false, false, false, false, false, false]
var armoursObtained = [false, false, false, false, false, false, false, false, false]
var silverVialsObtained = [false, false, false]
var upgradesObtained = [false, false, false, false]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func ObtainSilverVial():
	match curStage:
		stageList.Barracks:
			silverVialsObtained[0] = true
		stageList.Square:
			silverVialsObtained[1] = true
		stageList.EmporersChamber:
			silverVialsObtained[2] = true

func ObtainUpgrade():
	match curStage:
		stageList.Barracks:
			upgradesObtained[0] = true
		stageList.Chapel:
			upgradesObtained[1] = true
		stageList.Slums:
			upgradesObtained[2] = true
		stageList.Ashnora:
			upgradesObtained[3] = true

func ObtainHeart():
	heartsObtained[curStage] = true
	
func ObtainArmour():
	armoursObtained[curStage] = true

func KillBoss():
	deadBosses[curStage] = true
