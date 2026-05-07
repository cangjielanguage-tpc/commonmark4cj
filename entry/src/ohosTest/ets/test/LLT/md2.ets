export const err2: string = `
下面给出一份完整、可直接运行的 Python 版“推箱子”小游戏（控制台版）。  
- 使用方向键（或 WASD）控制人物 @  
- 将箱子 $ 推到目标点 .  
- 全部箱子都放到目标点上即可过关  
- 按 r 重置本关，按 q 退出  

运行环境：Python 3（无第三方依赖）。Linux / macOS 终端可直接跑；Windows 建议使用 Windows Terminal、PowerShell 或新版 CMD，以获得方向键支持。

---

### 1. 完整源码（保存为 sokoban.py）

\`\`\`python
#!/usr/bin/env python3
"""
极简控制台推箱子
作者：kimi 2025
"""

import sys
import tty
import termios
import os

# ------------------------- 关卡模板 -------------------------
# @ 玩家
# $ 箱子
# . 目标
# # 墙
# 空格 空地
LEVELS = [
  [
    "  #####",
    "  #   #",
    "  #$  #",
    "###  $##",
    "#.  $ @#",
    "## $ ##",
    " #   #",
    " #####"
  ],
  [
    "    #####",
    "    #   #",
    "    #$  #",
    "  ###  $##",
    "  #.  $ @#",
    "### # ## #",
    "#. .#  #",
    "#   ####",
    "#####"
  ],
  [
    "########",
    "#..  $ #",
    "#..#$##",
    "#.$ @ #",
    "#.$  ##",
    "########"
  ]
]

# ------------------------- 游戏逻辑 -------------------------

  class Sokoban:
  DIRS = {
    'w': (-1, 0),
    'a': (0, -1),
    's': (1, 0),
    'd': (0, 1),
    '\x1b[A': (-1, 0),  # ↑
    '\x1b[B': (1, 0),   # ↓
    '\x1b[C': (0, 1),   # →
    '\x1b[D': (0, -1),  # ←
  }

def __init__(self, level_idx=0):
self.level_idx = level_idx
self.load(level_idx)
self.history = []  # 用于撤销/重置

def load(self, idx):
raw = LEVELS[idx]
self.h = len(raw)
self.w = max(len(line) for line in raw)
  self.grid = [list(line.ljust(self.w)) for line in raw]
self.player = None
self.boxes = set()
self.targets = set()
for y in range(self.h):
for x in range(self.w):
ch = self.grid[y][x]
if ch == '@':
self.player = (y, x)
self.grid[y][x] = ' '
elif ch == '$':
self.boxes.add((y, x))
self.grid[y][x] = ' '
elif ch == '.':
self.targets.add((y, x))
self.grid[y][x] = ' '
elif ch == '*':  # 已放好的箱子
self.boxes.add((y, x))
self.targets.add((y, x))
self.grid[y][x] = ' '
elif ch == '+':  # 人在目标上
self.player = (y, x)
self.targets.add((y, x))
self.grid[y][x] = ' '
self.history = []

def draw(self):
os.system('clear' if os.name == 'posix' else 'cls')
print(f"Level {self.level_idx + 1}/{len(LEVELS)}  "
f"Boxes {len(self.boxes & self.targets)}/{len(self.targets)}")
for y in range(self.h):
line = ""
for x in range(self.w):
ch = self.grid[y][x]
pos = (y, x)
if pos == self.player:
line += ('@' if pos not in self.targets else '+')
elif pos in self.boxes:
line += ('$' if pos not in self.targets else '*')
elif pos in self.targets:
line += '.'
else:
  line += ch
print(line)
print("WASD / 方向键移动，r 重置，n 下一关，q 退出")

# 返回 True 表示移动成功
def move(self, dr, dc):
y, x = self.player
ny, nx = y + dr, x + dc
if self.grid[ny][nx] == '#':
return False
if (ny, nx) in self.boxes:
# 推箱子
bny, bnx = ny + dr, nx + dc
if self.grid[bny][bnx] == '#' or (bny, bnx) in self.boxes:
return False
self.boxes.remove((ny, nx))
self.boxes.add((bny, bnx))
self.player = (ny, nx)
return True

def solved(self):
return self.boxes == self.targets

def run(self):
while True:
self.draw()
if self.solved():
print("恭喜过关！")
key = self.get_key()
if key in ('q', 'Q'):
break
if key in ('n', 'N') and self.level_idx + 1 < len(LEVELS):
self.level_idx += 1
self.load(self.level_idx)
elif key in ('r', 'R'):
self.load(self.level_idx)
continue

key = self.get_key()
if key in ('q', 'Q'):
break
if key in ('r', 'R'):
self.load(self.level_idx)
continue
if key in ('n', 'N') and self.level_idx + 1 < len(LEVELS):
self.level_idx += 1
self.load(self.level_idx)
continue

if key in self.DIRS:
dr, dc = self.DIRS[key]
self.move(dr, dc)

@staticmethod
def get_key():
fd = sys.stdin.fileno()
old = termios.tcgetattr(fd)
try:
  tty.setraw(fd)
ch = sys.stdin.read(1)
if ch == '\x1b':  # 方向键
ch += sys.stdin.read(2)
finally:
  termios.tcsetattr(fd, termios.TCSADRAIN, old)
return ch


if __name__ == "__main__":
if len(sys.argv) > 1:
level = int(sys.argv[1]) - 1
else:
  level = 0
Sokoban(level).run()
\`\`\`

---

### 2. 运行方式

\`\`\`bash
python3 sokoban.py          # 从第 1 关开始
python3 sokoban.py 2        # 直接玩第 2 关
\`\`\`

---

### 3. 如何自定义关卡

在源码最上方 \`LEVELS\` 列表里按格式继续追加即可：

\`\`\`python
LEVELS.append([
  "#######",
  "#.....#",
  "#.$@$.#",
  "#######"
])
\`\`\`

---

### 4. 扩展思路

- **图形化**：用 \`pygame\` 或 \`tkinter\` 替换控制台绘制。  
- **撤销/重做**：把每一步状态压栈即可。  
- **关卡解析**：支持读取 \`.xsb\` / \`.sok\` 标准推箱子文件。  
- **自动求解**：实现广度优先搜索（BFS）+ 死剪枝算法。  

祝你玩得开心！
`