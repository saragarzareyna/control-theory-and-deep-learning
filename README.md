### Control Theory & Deep Learning: Aluminum Melting Furnace Temperature Modeling

This project aims to model the temperature control of one of Ronal Group's industrial aluminum melting furnaces, comparing a **classical control model** (transfer function + PID) against a **data-driven model** (1D CNN → FOPDT transfer function).

Ronal Group checks each wheel to ensure it meets their high quality standards.
One of the main issues they face is the appearance of microscopic cracks. When this happens, a process to evaluate possible solutions begins, and it sometimes ends with the wheel being remade.
They found the root cause to be temperature fluctuations when melting the alloy, which is why finding a solution was critical for their business.

The full report (in Spanish, developed as a final project for a Numerical Analysis for Non-Linear Optimization course) can be found in the repo, but the main points are described here.

Furnace temperature changes slowly (large time constant, dead time, gas-injector saturation) and is hit by disturbances (load changes, door openings, ambient temperature, sensor faults). Poor tuning causes overshoot, steady-state error and long settling times, which means wasted energy and defective wheels.
During the EDA, we found that operator-to-operator and shift-to-shift variability makes it worse. This was a key distinction from the rest of the projects presented to management, who greatly appreciated this insight.

The classical model uses a first-order plant with dead time. The delay was approximated by a first-order Padé, and a Lindberg/MPH Stack Tower Melter was used as a reference.
The Simulink model takes into consideration disturbances such as sensor faults, load/recharge, ambient temperature and a gas-injector saturation (max. 2 injectors).
The steady-state error was corrected with a gain via the Final Value Theorem. This closed-loop system has one real pole plus a complex pair (underdamped) and a right-half-plane zero (non-minimum phase), so the controller can't be too aggressive.

For the historical-data-based deep learning model, an EDA was the first step. It included a Power BI dashboard, classic EDA tools, clustering and a PCA.
From there, three models were created to arrive at the final CNN model used to compare deep learning techniques to classical control theory.
First, a Prophet model was used as a baseline forecast that follows setpoint changes well. Then, given the seemingly patterned behavior identified in the EDA, an LSTM was chosen.
Given its performance, a one-dimensional CNN was used as the final model --> RMSE 0.60 °C, MAE 0.40 °C, R² 0.989 (slight +1–2 °C bias).


**Comparison**

| | Classical model | CNN-based model |
|---|---|---|
| Closed-loop poles | 1 real + complex pair | 3 real |
| Response | Fast, overshoots 780 °C, oscillates | Smooth, overdamped, slower |
| Right-half-plane zero | ≈ +0.0033 | ≈ +0.0129 |
| Strength | Interpretable; good for PID design | Learns real operating behavior from data |

While powerful, the CNN loses interpretability and depends on data quality. Additionally, the heating time constant (τ) had to be constrained with physical knowledge.
In simulation, the CNN-based closed loop needed a much larger reference gain (~369 vs ~1.15), which reflects a scale difference in the identified model rather than a physical requirement.

On the technical side, we concluded neither approach is strictly better, and they complement each other. Classical control explains and justifies PID design. Deep learning extracts a realistic model from operating data, and the regimes found suggest gain-scheduling-style strategies for different operating conditions.
On the business side, since melting furnace specialists configure the furnace and we found a correlation between shift and setpoint, we recommended giving them the models, either as a dashboard showing predicted temperature or as a simulation tool to use before adjusting the furnace itself.


Note: the data provided by Ronal Group was not included for privacy reasons.
