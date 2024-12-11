```text
!pip install --upgrade tensorflow keras
!pip install --upgrade scikit-learn

# import necessary libraries
import numpy as np
import pandas as pd
import tensorflow as tf

from sklearn.model_selection import train_test_split
from tensorflow.keras import layers
#from tensorflow.keras.layers import preprocessing
from tensorflow.keras import preprocessing
```

```text
from tensorflow.keras.layers import Normalization

def get_normalization_layer(name, dataset):
  # Create a Normalization layer for our feature.
  normalizer = preprocessing.Normalization(axis=None)

# TODO
  # Prepare a Dataset that only yields our feature.
  feature_ds = dataset.map(lambda x, y: x[name])

  # Learn the statistics of the data.
  normalizer.adapt(feature_ds)

  return normalizer
```
