import numpy as np 
import matplotlib.pyplot as plt 

plt.style.use('seaborn-whitegrid')
plt.rcParams["font.family"] = "Times New Roman"
plt.rcParams["font.size"] = 8

fig, axs = plt.subplots(3, 2)

def add_plot(not_fluent, partially_fluent, fluent, not_adequate, partially_adequate, adequate, marker, color, ax1, ax2, label=None, alpha=0.75):
    fluency = 1.0 * fluent + 0.5 * partially_fluent + 0.0 * not_fluent
    adequacy = 1.0 * adequate + 0.5 * partially_adequate + 0.0 * not_adequate
    axs[ax1, ax2].grid(alpha=0.25)
    axs[ax1, ax2].scatter(fluency, adequacy, marker=marker, s=20, alpha=alpha, c=color, label=label)

# In-Domain 

# 5k
add_plot(18, 6, 1, 21, 3, 1, marker='+', color='b', ax1=0, ax2=0, label='T. Base')
add_plot(19, 5, 1, 23, 2, 0, marker=',', color='g', ax1=0, ax2=0, label='T. Optim')
add_plot(15, 9, 1, 23, 2, 0, marker='o', color='y', ax1=0, ax2=0, label='RNN')
add_plot(0, 9, 16, 9, 10, 5, marker='v', color='r', ax1=0, ax2=0, label='mBART25')
add_plot(16, 6, 3, 23, 2, 0, marker='^', color='c', ax1=0, ax2=0, label='T. Base + SR')
add_plot(22, 1, 2, 25, 0, 0, marker='<', color='m', ax1=0, ax2=0, label='T. Optim + D')

# 10k 
add_plot(15, 9, 1, 22, 3, 0, marker='+', color='b', ax1=0, ax2=1)
add_plot(16, 6, 3, 21, 3, 1, marker=',', color='g', ax1=0, ax2=1)
add_plot(14, 10, 1, 21, 4, 0, marker='o', color='y', ax1=0, ax2=1)
add_plot(1, 6, 18, 9, 11, 5, marker='v', color='r', ax1=0, ax2=1)
add_plot(14, 10, 1, 24, 1, 0, marker='^', color='c', ax1=0, ax2=1)
add_plot(17, 5, 3, 24, 1, 0, marker='<', color='m', ax1=0, ax2=1)

# 20k 
add_plot(11, 12, 3, 15, 8, 2, marker='+', color='b', ax1=1, ax2=0)
add_plot(8, 10, 7, 19, 4, 1, marker=',', color='g', ax1=1, ax2=0)
add_plot(8, 12, 5, 21, 4, 0, marker='o', color='y', ax1=1, ax2=0)
add_plot(0, 7, 18, 7, 7, 11, marker='v', color='r', ax1=1, ax2=0)
add_plot(6, 14, 5, 23, 1, 1, marker='^', color='c', ax1=1, ax2=0)
add_plot(13, 8, 4, 22, 2, 1, marker='<', color='m', ax1=1, ax2=0)

# 40k
add_plot(7, 13, 5, 17, 6, 5, marker='+', color='b', ax1=1, ax2=1)
add_plot(3, 16, 6, 16, 6, 3, marker=',', color='g', ax1=1, ax2=1)
add_plot(8, 14, 3, 14, 7, 4, marker='o', color='y', ax1=1, ax2=1)
add_plot(0, 6, 19, 5, 7, 13, marker='v', color='r', ax1=1, ax2=1)
add_plot(6, 11, 8, 12, 9, 4, marker='^', color='c', ax1=1, ax2=1)
add_plot(12, 5, 8, 16, 8, 1, marker='<', color='m', ax1=1, ax2=1)

# 80k
add_plot(3, 14, 8, 14, 6, 5, marker='+', color='b', ax1=2, ax2=0)
add_plot(0, 8, 17, 7, 8, 10, marker=',', color='g', ax1=2, ax2=0)
add_plot(0, 4, 21, 4, 11, 10, marker='v', color='r', ax1=2, ax2=0)
add_plot(0, 11, 14, 13, 6, 6, marker='^', color='c', ax1=2, ax2=0)
add_plot(0, 4, 21, 12, 7, 6, marker='<', color='m', ax1=2, ax2=0)

# 160k
add_plot(0, 7, 18, 6, 13, 6, marker='+', color='b', ax1=2, ax2=1)
add_plot(1, 6, 19, 12, 3, 10, marker=',', color='g', ax1=2, ax2=1)
add_plot(1, 9, 15, 5, 9, 10, marker='v', color='r', ax1=2, ax2=1)
add_plot(0, 10, 15, 10, 9, 6, marker='^', color='c', ax1=2, ax2=1)
add_plot(0, 9, 16, 6, 12, 7, marker='<', color='m', ax1=2, ax2=1)

axs[0, 0].set_xlim(0, 25)
axs[0, 0].set_ylim(0, 25)
axs[0, 0].set_title('5K')

axs[0, 1].set_xlim(0, 25)
axs[0, 1].set_ylim(0, 25)
axs[0, 1].set_title('10K')

axs[1, 0].set_xlim(0, 25)
axs[1, 0].set_ylim(0, 25)
axs[1, 0].set_title('20K')

axs[1, 1].set_xlim(0, 25)
axs[1, 1].set_ylim(0, 25)
axs[1, 1].set_title('40K')

axs[2, 0].set_xlim(0, 25)
axs[2, 0].set_ylim(0, 25)
axs[2, 0].set_title('80K')

axs[2, 1].set_xlim(0, 25)
axs[2, 1].set_ylim(0, 25)
axs[2, 1].set_title('160K')

axs[0, 0].xaxis.set_ticklabels([])
axs[0, 1].yaxis.set_ticklabels([])
axs[0, 1].xaxis.set_ticklabels([])

axs[1, 0].xaxis.set_ticklabels([])
axs[1, 1].yaxis.set_ticklabels([])
axs[1, 1].xaxis.set_ticklabels([])

axs[2, 1].yaxis.set_ticklabels([])

handles, labels = axs[0, 0].get_legend_handles_labels()
fig.legend(handles, labels, loc='upper center', ncol=6)
fig.text(0.5, 0.04, 'Fluency', ha='center')
fig.text(0.04, 0.5, 'Adequacy', va='center', rotation='vertical')
plt.savefig('manual_eval_id', dpi=300)
#plt.show()
