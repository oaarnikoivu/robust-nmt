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
add_plot(17, 5, 3, 25, 0, 0, marker='+', color='b', ax1=0, ax2=0, label='T. Base')
add_plot(21, 2, 2, 23, 2, 0, marker=',', color='g', ax1=0, ax2=0, label='T. Optim')
add_plot(20, 3, 2, 24, 1, 0, marker='o', color='y', ax1=0, ax2=0, label='RNN')
add_plot(3, 11, 11, 16, 8, 1, marker='v', color='r', ax1=0, ax2=0, label='mBART25')
add_plot(16, 7, 2, 25, 0, 0, marker='^', color='c', ax1=0, ax2=0, label='T. Base + SR')
add_plot(23, 1, 1, 24, 1, 0, marker='<', color='m', ax1=0, ax2=0, label='T. Optim + D')

# 10k 
add_plot(17, 4, 4, 23, 2, 0, marker='+', color='b', ax1=0, ax2=1)
add_plot(15, 5, 5, 22, 3, 0, marker=',', color='g', ax1=0, ax2=1)
add_plot(16, 5, 4, 21, 4, 0, marker='o', color='y', ax1=0, ax2=1)
add_plot(5, 9, 11, 11, 6, 7, marker='v', color='r', ax1=0, ax2=1)
add_plot(8, 15, 2, 24, 1, 0, marker='^', color='c', ax1=0, ax2=1)
add_plot(23, 2, 0, 25, 0, 0, marker='<', color='m', ax1=0, ax2=1)

# 20k 
add_plot(15, 7, 3, 24, 1, 0, marker='+', color='b', ax1=1, ax2=0)
add_plot(13, 9, 3, 24, 1, 0, marker=',', color='g', ax1=1, ax2=0)
add_plot(15, 6, 4, 22, 3, 0, marker='o', color='y', ax1=1, ax2=0)
add_plot(5, 10, 10, 16, 7, 3, marker='v', color='r', ax1=1, ax2=0)
add_plot(11, 8, 5, 22, 3, 0, marker='^', color='c', ax1=1, ax2=0)
add_plot(16, 6, 3, 23, 2, 0, marker='<', color='m', ax1=1, ax2=0)

# 40k
add_plot(16, 8, 1, 23, 2, 0, marker='+', color='b', ax1=1, ax2=1)
add_plot(13, 8, 4, 21, 2, 2, marker=',', color='g', ax1=1, ax2=1)
add_plot(11, 11, 3, 23, 2, 0, marker='o', color='y', ax1=1, ax2=1)
add_plot(1, 11, 13, 16, 4, 5, marker='v', color='r', ax1=1, ax2=1)
add_plot(11, 7, 7, 22, 1, 2, marker='^', color='c', ax1=1, ax2=1)
add_plot(12, 7, 6, 21, 3, 1, marker='<', color='m', ax1=1, ax2=1)

# 80k
add_plot(12, 8, 5, 22, 3, 0, marker='+', color='b', ax1=2, ax2=0)
add_plot(3, 11, 11, 16, 7, 2, marker=',', color='g', ax1=2, ax2=0)
add_plot(0, 7, 17, 10, 9, 6, marker='v', color='r', ax1=2, ax2=0)
add_plot(5, 15, 5, 20, 4, 1, marker='^', color='c', ax1=2, ax2=0)
add_plot(5, 6, 14, 14, 8, 3, marker='<', color='m', ax1=2, ax2=0)

# 160k
add_plot(9, 7, 9, 17, 7, 1, marker='+', color='b', ax1=2, ax2=1)
add_plot(6, 7, 12, 12, 9, 4, marker=',', color='g', ax1=2, ax2=1)
add_plot(0, 5, 19, 9, 11, 4, marker='v', color='r', ax1=2, ax2=1)
add_plot(3, 12, 10, 18, 5, 2, marker='^', color='c', ax1=2, ax2=1)
add_plot(4, 7, 14, 12, 8, 5, marker='<', color='m', ax1=2, ax2=1)

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
plt.savefig('manual_eval_ood', dpi=300)
#plt.show()
