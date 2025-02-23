
# THE CLI TODO LIST

Hello there, I hope you are doing well, this script is a **simple CLI-based to-do list** app.

It connects to Supabase to retrieve and store everything.

## Supabase

You need to go to `https://supabase.com/`, make an account, and create a new project naming it whatever you want.

Then you can go to `SQL editor` in the left sidebar, and click the small `+` icon. Copy the script in `supabase.sql` in this repo and paste it there. That will create the table.

---

## CLI tool install

Once you have a table running, go to `Project settings > Data API` and copy the `Project URL`. Paste that in the `ToDo_CLI.sh` file at the top where it says `SUPABASE_URL`.

Then, you need to do the same for `Project API Keys` making sure to use the anon public key, and put it in the `SUPABASE_API_KEY` path of the `ToDo_CLI.sh`.

---

## Installation

Once you have done those other parts, you can now relax and run these commands in your terminal:

```bash
./installation.sh
```

I wrote the rest in the `installation.sh`, so it will take care of itself and install the script :)

In the wild case it does not work, just make `installation.sh` executable by running:

```bash
chmod +x installation.sh

# Then you should run to install the script :)
sudo ./installation.sh
```

---

## Usage

After installation, you can start using the tool via the command line.

### 1. **Add a Task**

To add a new task to both your local queue and Supabase, use:

```bash
todo commit-m "Your task message"
```

Example:

```bash
todo commit-m "Buy groceries"
```

This will add the task "Buy groceries" to your local task queue and push it to Supabase.

### 2. **List All Tasks**

To list all tasks from both your local queue and Supabase, use:

```bash
todo list
```

This will show all the tasks from the local file and also fetch them from Supabase.

### 3. **Delete a Specific Task**

#### From Local

To delete a task from the local file based on its ID:

```bash
todo delete local <task_id>
```

Example:

```bash
todo delete local 10
```

This will remove the task with ID `10` from the local queue.

#### From Supabase

To delete a task from Supabase by ID:

```bash
todo delete <task_id>
```

Example:

```bash
todo delete 10
```

This will remove the task with ID `10` from Supabase.

### 4. **Delete All Local Tasks**

To remove all tasks from the local queue, use:

```bash
todo delete local -a
```

This will clear all tasks from the local file.

### 5. **Delete All Tasks from Local and Supabase**

To delete all tasks from both local storage and Supabase, use:

```bash
todo delete -a
```

This will remove all tasks from both locations.

---

## Example Workflow

1. Add tasks:

```bash
todo commit-m "Task 1"
todo commit-m "Task 2"
```

2. List tasks:

```bash
todo list
```

3. Delete a task from local:

```bash
todo delete local 1
```

4. Delete a task from Supabase:

```bash
todo delete 2
```

5. Clear all tasks locally:

```bash
todo delete local -a
```

6. Clear all tasks from both local and Supabase:

```bash
todo delete -a
```

---

Feel free to reach out if you have any issues! Happy task managing 😊
