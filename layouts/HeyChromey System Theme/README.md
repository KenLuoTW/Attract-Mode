# Attract-Mode Plus v3.0.2
# ${\color{red}HeyChromey\ System\ Theme}$
![image](HeyChromey%20System%20Theme.png)

主題素材提取自 [RetroHursty69](https://github.com/RetroHursty69) 為 EmulationStation 所製作的主題，當初看到後覺得很適合拿來作為主選單及平台系統選單，於是便將它移植至 Attract-Mode 來使用。

此主題為 Attract-Mode Plus 限定主題， 不過 Attract-Mode Plus 在 3.0.2 之後的版本，捨棄了預設字型的設定，這使得在設定介面中會連基本的中文標點符號都無法顯示。在 3.0.9 之後的開發版，更是在過濾條件為 `等於` 時直接返為 0，所以建議維持使用 Attract-Mode Plus v3.0.2 版本即可。

## 安裝及設定:
1. 將 [HeyChromey System Theme.zip](https://github.com/KenLuoTW/Attract-Mode/releases/download/v1.0.0-2/HeyChromey.System.Theme.zip) 解壓至 Attract-Mode 資料夾
2. 進入 Attract-Mode 設定，設定輸入控制 (鍵盤 / XBOX 手把建議設定)
   - 返回 (結束) : Esc 或 JoyX Button1
   - ↑ (上一個遊戲) : Up 或 JoyX Up
   - ↓ (下一個遊戲) : Down 彧 JoyX Down
   - ← (上一頁) : Left 彧 JoyX Left
   - → (下一頁) : Right 或 JoyX Right
   - 選擇 : Return 或 JoyX Button0
   - 上一頁 : PageUp 彧 JoyX Button4
   - 下一頁 : PageDown 或 JoyX Button5
   - 自訂 2 : Insert 或 JoyX Button7
3. 遊戲系統的環狀圖標請放在 `Attract-Mode 資料夾/menu-art/wheel`，圖標可由 [RetroHursty69](https://github.com/RetroHursty69) 以下幾處的作品取得
   - [es-theme-heychromey](https://github.com/RetroHursty69/es-theme-heychromey)
   - [HurstyCreations-RoundChromeWheels](https://github.com/RetroHursty69/HurstyCreations-RoundChromeWheels)
   - [HurstyCreations-RoundChromeWheelsPart2](https://github.com/RetroHursty69/HurstyCreations-RoundChromeWheelsPart2)
4. 遊戲系統的視訊請放在 `Attract-Mode 資料夾/menu-art/themes`
5. 遊戲系統的背景請放在 `Attract-Mode 資料夾/menu-art/bg`

## 自訂設定:
本主題可以支援統計各遊戲系統下的遊戲數量，如果你須要使用別人所製作的遊戲系統主題，你須要在該遊戲主題的 `layout.nut` 裡加上下面一段代碼:

```
/////////////////////////////////////////////////////////////////////////////////
// System games count
/////////////////////////////////////////////////////////////////////////////////
count_infos <- {};
local curr_sys = fe.list.name;

if (fe.list.search_rule != "Tags contains search_results")
{
	if (!file_exist(FeConfigDirectory + "themes/HeyChromey/countstats/" + fe.list.name + ".stats")) 
	{
		count_infos[curr_sys] <- {"cnt":fe.filters[0].size};
		SaveStats(count_infos, curr_sys);
	}
	else
	{
		count_infos = LoadStats(curr_sys);
		if (count_infos.rawin(curr_sys))
		{
			if(fe.filters[0].size != count_infos[curr_sys].cnt)
			{
				count_infos[curr_sys].cnt = fe.filters[0].size;
				SaveStats(count_infos, curr_sys);
			}
		}
	}
}
```

並修改 `HeyChromey Main Menu Theme\layout.nut` 裡的 Platforms 資訊，例如所新增的遊戲系統，顯示介面名稱為 PS2:

```
Platforms <- {
	Arcade = ["街機平台", "遊戲", "CPS1", "CPS2", "CPS3", "MAME", "MODEL2", "MODEL3", "MVS", "NAOMI"],
	Console = ["家用機平台", "遊戲", "Dreamcast", "FC", "FDS", "Genesis", "MD", "MDCD", "N64", "N64DD",
		   "NeoGeo", "NeoGeoCD", "NES", "NGC", "PCE", "PCECD", "PCFX", "PS", "Saturn", "SEGA32X",
		   "SEGACD", "SFC", "SNES", "SuperACan", "SuperGrafx", "TG16", "TGCD", "PS2"],
	Handheld = ["掌機平台", "遊戲", "GBA", "GG", "NDS", "PSP"],
	Computer = ["電腦平台", "遊戲", "MS-DOS", "MSX", "MSX2", "Windows"],
	Multimedia = ["多媒體", "系統"]
}
```


[![image](https://img.youtube.com/vi/JN4bo48t3Qg/0.jpg)](https://www.youtube.com/watch?v=JN4bo48t3Qg)


[![image](https://img.youtube.com/vi/LLE53MMjNOs/0.jpg)](https://www.youtube.com/watch?v=LLE53MMjNOs)
