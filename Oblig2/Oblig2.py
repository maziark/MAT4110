from PIL import Image
import numpy as np
from numpy.linalg import svd
import matplotlib.pyplot as plt


def image_to_numpy(path, black_white=True):
    img = Image.open(path)
    if black_white:
        img = img.convert('L')
    return np.asarray(img)


def numpy_to_image(np_array):
    return Image.fromarray(np_array * 255)


def normalize_array(np_array):
    return np_array / 255


def compress_matrix(matrix, rate=2):
    U, S, V = svd(matrix, full_matrices=False)
    n = int(S.shape[0] / rate)
    compressed_matrix = U[:, :n] @ np.dot(
        np.diag(S[:n]), V[:n, :])

    to_be_stored = U[:, :n].shape[0] * U[:, :n].shape[1] + S[:n].shape[0] + V[:n, :].shape[0] * V[:n, :].shape[1]

    return compressed_matrix, to_be_stored, S


def plot_multiple_images(fig_list, subs_list=[], title=''):
    (x, y) = len(fig_list), len(fig_list[0])
    fig, axes = plt.subplots(x, y)
    # assert (len(fig_list) == len(subs_list))

    for i in range(x):
        for j in range(y):
            axes[i][j].imshow(fig_list[i][j], cmap='gray')
            axes[i][j].set_title('rate={}'.format(2 ** (i * 3 + j)))
    fig.show()
    fig.savefig('Compare_compressed/{}.png'.format(title))


def plot_single_image(image, rate):
    images = [[image_to_numpy('board-157165_1280.png'), 'board'],
              [image_to_numpy('jellyfish-698521_1280.jpg'), 'jellyfish'],
              [image_to_numpy('new-york-690868_1280.jpg'), 'new_york']]
    fig, axes = plt.subplots(2, 1)
    axes[0].imshow(images[image][0], cmap='gray')
    axes[0].set_title('original picture')
    tmp, _, _ = compress_matrix(images[image][0], 2 ** rate)
    axes[1].imshow(tmp, cmap='gray')
    axes[1].set_title('compressed by {}'.format(2 ** rate))

    fig.show()
    fig.savefig('final_version/{}_vs_original.png'.format(images[image][1]))


def plot_compressed_images(img_number):
    images = [[image_to_numpy('board-157165_1280.png'), 'board'],
              [image_to_numpy('jellyfish-698521_1280.jpg'), 'jellyfish'],
              [image_to_numpy('new-york-690868_1280.jpg'), 'new_york']]
    output = [[], [], []]
    for i in range(0, 9):
        compressed_version, new_size, _ = compress_matrix(images[img_number][0], 2 ** i)
        print(i, new_size)
        output[int(i / 3)].append(compressed_version)

    plot_multiple_images(output, title=images[img_number][1])


def plot_log_s_values():
    images = [[image_to_numpy('board-157165_1280.png'), 'board'],
              [image_to_numpy('jellyfish-698521_1280.jpg'), 'jellyfish'],
              [image_to_numpy('new-york-690868_1280.jpg'), 'new_york']]

    for image in images:
        _, _, S = compress_matrix(image[0], 1)
        plt.figure()
        plt.plot(np.log(S))
        plt.title(image[1])
        plt.ylabel('log(s)')
        plt.savefig('log_results/log_svd_{}.png'.format(image[1]))


if __name__ == '__main__':
    plot_compressed_images(2)
    plot_log_s_values()
    # plot_single_image(2, 3)
