import pandas as pd
import matplotlib.pyplot as plt

def plot_courbes_moyennes(csv_path):
    df = pd.read_csv(csv_path)

    # Calcul des moyennes
    moyennes = (
        df.groupby(["model", "n"])["left_subtree_size"]
        .mean()
        .reset_index()
    )

    couleurs = {
        "remy_lineaire": "blue",
        "abr": "green"
    }

    plt.figure()

    for structure, couleur in couleurs.items():
        subset = moyennes[moyennes["model"] == structure]

        # Important : trier par taille
        subset = subset.sort_values("n")

        plt.plot(
            subset["n"],
            subset["left_subtree_size"]/subset["n"],
            label=structure,
            color=couleur,
            marker="o"
        )

    plt.xlabel("Taille (n)")
    plt.ylabel("Taille du sous-arbre gauche / taille totale de l'arbre")
    plt.title("Taille du sous-arbre gauche en fonction de la taille")
    plt.legend()
    plt.grid(True)

    plt.savefig("taille_fils_vs_taille.png", dpi=300, bbox_inches="tight")
    plt.close()

plot_courbes_moyennes("experiments.csv")