# Attract-Mode Plus v3.0.2
# ${\color{red}HeyChromey\ Main\ Menu\ Theme\ (Build\ 20250315)}$
![image](HeyChromey%20Main%20Menu%20Theme.png)

主題素材提取自 [RetroHursty69](https://github.com/RetroHursty69) 為 EmulationStation 所製作的主題，當初看到後覺得很適合拿來作為主選單及平台系統選單，於是便將它移植至 Attract-Mode 來使用。

此主題為 Attract-Mode Plus 限定主題， 不過 Attract-Mode Plus 在 3.0.2 之後的版本，捨棄了預設字型的設定，這使得在設定介面中會連基本的中文標點符號都無法顯示。在 3.0.9 之後的開發版，更是在過濾條件為 `等於` 時直接返為 0，所以建議維持使用 Attract-Mode Plus v3.0.2 版本即可。

## 安裝及設定:
1. 將 [HeyChromey.Main.Menu.Theme_Build_20250315.zip](https://github.com/KenLuoTW/Attract-Mode/releases/download/v1.0.0-1/HeyChromey.Main.Menu.Theme_Build_20250315.zip) 解壓至 Attract-Mode 資料夾
2. 將 [HeyChromey.Main.Menu.Theme_Media.zip](https://github.com/KenLuoTW/Attract-Mode/releases/download/v1.0.0-1/HeyChromey.Main.Menu.Theme_Media.zip) 解壓至 Attract-Mode 資料夾
3. 將 [common_Build_20250315.zip](https://github.com/KenLuoTW/Attract-Mode/releases/download/v1.0.0-4/common_Build_20250315.zip) 解壓至 Attract-Mode 資料夾
4. 進入 Attract-Mode 設定，設定輸入控制 (鍵盤 / XBOX 手把建議設定)
   - 返回 (結束) : Esc 或 JoyX Button1
   - ↑ (上一個遊戲) : Up 或 JoyX Up
   - ↓ (下一個遊戲) : Down 彧 JoyX Down
   - ← (上一頁) : Left 彧 JoyX Left
   - → (下一頁) : Right 或 JoyX Right
   - 選擇 : Return 或 JoyX Button0
   - 上一頁 : PageUp 彧 JoyX Button4
   - 下一頁 : PageDown 或 JoyX Button5
   - 自訂 2 : Insert 或 JoyX Button7
5. 平台的環狀圖標請放在 `Attract-Mode 資料夾/menu-art/wheel`，圖標可由 [RetroHursty69](https://github.com/RetroHursty69) 以下幾處的作品取得
   - [es-theme-heychromey](https://github.com/RetroHursty69/es-theme-heychromey)
   - [HurstyCreations-RoundChromeWheels](https://github.com/RetroHursty69/HurstyCreations-RoundChromeWheels)
   - [HurstyCreations-RoundChromeWheelsPart2](https://github.com/RetroHursty69/HurstyCreations-RoundChromeWheelsPart2)

## 自訂設定:
本主題可以支援統計各平台下的遊戲數量，如果你須要使用別人所製作的遊戲系統主題，你須要在該遊戲主題的 `layout.nut` 裡的 `UserConfig` 加上:
```
</ label="預設系統平台", help="設定遊戲數量要計算在主選單的哪個平台", options="街機平台,家用機平台,掌機平台,電腦平台,遊戲合集,多媒體", order=orderx++ /> default_gameplatform="電腦平台";
```

並在適合的地方加上下面一段代碼:

```
/////////////////////////////////////////////////////////////////////////////////
// System games count
/////////////////////////////////////////////////////////////////////////////////
local curr_sys = fe.list.name;
local curr_plat = my_config["default_gameplatform"];
local curr_count = fe.filters[0].size;

if (fe.list.search_rule == "")
{
	if (!fe.nv.GameCount.rawin(curr_plat)) fe.nv.GameCount[curr_plat] <- {};
	
	if (fe.nv.GameCount[curr_plat].rawin(curr_sys))
	{
		if (curr_count == fe.nv.GameCount[curr_plat][curr_sys])
			fe.nv.GameCount[curr_plat][curr_sys] <- fe.filters[0].size;
	}
	else
	{
		fe.nv.GameCount[curr_plat][curr_sys] <- fe.filters[0].size;
	}
}
```

之後開啟 Attract-Mode 並切換到該遊戲主題設定畫面佈局，即可看到該選項，將其設定至適合的平台即可。
![image](HeyChromey%20Main%20Menu%20Theme_1.png)


[![image](https://img.youtube.com/vi/LLE53MMjNOs/0.jpg)](https://www.youtube.com/watch?v=LLE53MMjNOs)
