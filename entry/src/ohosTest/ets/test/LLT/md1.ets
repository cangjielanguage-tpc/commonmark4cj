export const errjson: string = `
高斯公式（Gauss's Divergence Theorem，高斯散度定理）
一句话：把三维空间里的 **“体积分”** 与 **“面积分”** 互相转化的公式。

---

### 1. 公式写法
设 **\( \Omega \subset \mathbb{R}^3 \)** 是一个由光滑封闭曲面 **\( \partial\Omega \)** 包围的有界区域，
向量场 **\( \mathbf{F}(x,y,z) = (P,Q,R) \)** 在 **\( \Omega\cup\partial\Omega \)** 上连续可微，则

\[
\boxed{
\iiint_{\Omega} (\nabla \cdot \mathbf{F})\, dV
=
\iint_{\partial\Omega} \mathbf{F}\cdot \mathbf{n}\, dS
}
\]

- 左边：散度的 **体积分**
- 右边：通量的 **面积分**（\( \mathbf{n} \) 为外法向单位向量）

---

### 2. 物理意义
- **源与汇的总量**
  左边统计区域 **\( \Omega \)** 内所有点的“发散程度”之和。
  右边统计穿过边界 **\( \partial\Omega \)** 的“净流出量”。
  二者相等，即 **区域内产生的总量 = 区域边界流出的总量**。

- 常见场景
  - 电磁场：麦克斯韦方程组中高斯定律的微分/积分形式互换。
  - 流体力学：质量/能量守恒方程的推导。
  - 热传导：热流密度与温度场的关系。

---

### 3. 二维简化：格林公式
高斯公式在二维退化为格林公式（Green's Theorem）：

\[
\iint_D \left( \frac{\partial Q}{\partial x} - \frac{\partial P}{\partial y} \right) dxdy
=
\oint_{\partial D} (P\,dx + Q\,dy)
\]

---

### 4. 记忆口诀
**“体散度，面通量，高斯帮你搭桥梁。”**
`