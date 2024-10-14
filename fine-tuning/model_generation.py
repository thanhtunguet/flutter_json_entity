import json
import os

import pandas as pd
from datasets import Dataset
from transformers import (AutoModelForCausalLM, AutoTokenizer, Trainer,
                          TrainingArguments)

# Folder containing the code snippets
folder_path = "./model-generation"

# Function to determine if a file represents a plural entity
def is_plural(filename):
    return filename.endswith('s.json')

# Function to read JSON and Dart pairs
def load_code_snippets(folder_path):
    data = []
    for filename in os.listdir(folder_path):
        if filename.endswith(".json"):
            entity_name = filename[:-5]  # Remove .json extension
            dart_filename = entity_name[:-1] + ".dart" if is_plural(filename) else entity_name + ".dart"
            json_file = os.path.join(folder_path, filename)
            dart_file = os.path.join(folder_path, dart_filename)
            
            if os.path.exists(dart_file):
                # Read JSON and Dart files
                with open(json_file, 'r') as jf, open(dart_file, 'r') as df:
                    json_content = jf.read()
                    dart_content = df.read()
                    
                    # Adjust prompt based on whether it's a singular or plural entity
                    if is_plural(filename):
                        prompt = f"Convert the following array of JSON entities to Flutter model classes:\n{json_content}\n"
                    else:
                        prompt = f"Convert the following JSON to a Flutter model class:\n{json_content}\n"
                    
                    # Add prompt-completion pair to the dataset
                    data.append({"prompt": prompt, "completion": dart_content})
    
    return data

# Load the dataset from the folder
data = load_code_snippets(folder_path)

# Convert the data into Hugging Face Dataset format
dataset = Dataset.from_pandas(pd.DataFrame(data))

# Load pre-trained model and tokenizer
model_name = "gpt-3.5-turbo"  # You can replace this with the model you prefer
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

# Tokenize the dataset
def tokenize_function(example):
    return tokenizer(example['prompt'], text_target=example['completion'], truncation=True)

tokenized_datasets = dataset.map(tokenize_function, batched=True)

# Define training arguments
training_args = TrainingArguments(
    output_dir="./fine-tuned-model",
    evaluation_strategy="steps",
    eval_steps=500,
    per_device_train_batch_size=2,
    per_device_eval_batch_size=2,
    num_train_epochs=3,
    logging_steps=500,
    save_steps=1000,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='./logs',
    learning_rate=2e-5
)

# Initialize the trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets,
)

# Fine-tune the model
trainer.train()

# Save the fine-tuned model
model.save_pretrained("./fine-tuned-model")
tokenizer.save_pretrained("./fine-tuned-model")
