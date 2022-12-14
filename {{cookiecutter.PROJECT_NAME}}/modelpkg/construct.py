import logging
import math
import os
from dataclasses import dataclass

import numpy as np

# enable logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("Model workflow")

FILE_MODEL = 'model.npy'


def simulate_salaries(n: int = 1000, sigma: float = 1e+3) -> tuple:
    """Simulate data for ages and salaries

    Args:
        n (int, optional): Number of observations.
            Defaults to 1000.

    Returns:
        tuple: age, salary.
    """
    logger.info(f'Simulating {n} observations')
    age = np.random.randint(size=n, low=20, high=70)
    e = np.random.randn(n) * sigma
    salary = sigma * np.array(age) + e
    return age, salary


@dataclass
class Model:
    slope: float = None
    intercept: float = None

    def train(self, age: np.ndarray, salary: np.ndarray) -> None:
        n = age.shape[0]
        logger.info(f'Training model on {n} observations')
        X = np.vstack([age, np.ones(n)]).T
        slope, intercept = np.linalg.lstsq(X, salary, rcond=None)[0]
        logger.info(f'Fitted model: slope = {round(slope, 3)}, intercept = {round(intercept, 3)}')
        self.slope = slope
        self.intercept = intercept

    def predict(self, age: int) -> np.float64:
        return self.intercept + self.slope * age

    def evaluate(self, age: np.ndarray, salary: np.ndarray) -> np.float64:
        preds = self.predict(age)
        MSE = np.square(np.subtract(preds, salary)).mean()
        RMSE = math.sqrt(MSE)
        logger.info(f'RMSE = {round(RMSE, 3)}')
        return RMSE

    def save(self, dir: str = ".", file: str = FILE_MODEL) -> None:
        artifact = (self.slope, self.intercept)
        filepath = os.path.join(dir, file)
        logger.info(f'writing model to {filepath}')
        np.save(filepath, artifact)

    def load(self, dir: str = ".", file: str = FILE_MODEL) -> None:
        filepath = os.path.join(dir, file)
        logger.info(f'Loading model from file {filepath}')
        self.slope, self.intercept = np.load(filepath)
